def consolidate_cart(cart)
  
  new_hash = {}
  #Get all items in cart array to hash array 
  cart.each do |data|
    #puts "data = #{data}"
    data.each do |data_items, cost_discount|
      #puts "data_items = #{data_items}"
      if new_hash[data_items] == nil
        #Create new_hash with items
        new_hash[data_items] = cost_discount
        new_hash[data_items][:count] = 1
      else
        #item data_items exists and update count
        total = new_hash[data_items][:count]
        total = total + 1
        new_hash[data_items][:count] = total
      end
   end
  end
  #puts "new_hash = #{new_hash}"

  new_hash
end #consolidate_cart



def apply_coupons(cart, coupons)

 #Initialize items for scope
  coupon_hash = {}
  name_item = "" 
  sale_num_required = 0
  sale_item_cost = 0
  add_item_hash = {}
  get_item_count = 0

  coupon_hash = {}
  coupons.each do |coupon_item|
    coupon_item.each do |c_key, c_value|
      if  c_key == :item 
        if coupon_hash[c_value] == nil
          coupon_hash[c_value] = {}
          name_item = c_value
        else
          update_count = coupon_hash[c_value][:coupon_count]
          coupon_hash[c_value][:coupon_count] = update_count + 1
        end
      elsif c_key == :num
        coupon_hash[name_item][c_key] = c_value
      else
        coupon_hash[name_item][c_key] = c_value
        num_total = coupon_hash[name_item][:coupon_count]
        if num_total == nil
          coupon_hash[name_item][:coupon_count] = 1
        end
      end
    end
  end
 
  #Begin scanning coupons
  coupon_hash.each do |sale_item, sale_data|
     #Begin scanning through cart items
    cart.each do |cart_item, cart_data| #item"BEER", data{:price=>13.0,...}
      #Begin checking if coupon items scanned are in cart
      if cart_item == sale_item
        sale_num_required = coupon_hash[sale_item][:num]
        sale_item_cost = coupon_hash[sale_item][:cost]
        duplicate_coupons = coupon_hash[sale_item][:coupon_count]
        while duplicate_coupons >= 1
          get_item_count = cart[cart_item][:count]
          is_coupon_valid = get_item_count - sale_num_required
          if is_coupon_valid >= 0
             key_string = sale_item
             key_string = "#{sale_item} W/COUPON"
             if !add_item_hash[key_string]
               add_item_hash[key_string] = {}
               add_item_hash[key_string][:price] = sale_item_cost
               add_item_hash[key_string][:clearance] = cart[cart_item][:clearance]
               add_item_hash[key_string][:count] = 1
               cart[cart_item][:count] = is_coupon_valid
             elsif  add_item_hash[key_string][:count] >= 1
               update_count = add_item_hash[key_string][:count]
               update_count = update_count + 1
               add_item_hash[key_string][:count] = update_count
               cart[cart_item][:count] = is_coupon_valid
             end

          else 
          #Do nothing since can't apply coupon
            puts "Can't apply coupon"
          end #if is_coupon_valid
          duplicate_coupons = duplicate_coupons - 1
        end #while loop
        #update grocery_item

        
        
      end #if cart_item == sale_item

    end #cart.each
  end #coupon_hash.each
  consolidated_hash = cart.merge(add_item_hash)

  consolidated_hash
  
end #apply_coupons


def apply_clearance(cart)
  discounted_value = 0.80  #20% (1 - .20)
  cart.each do |cart_item, cart_data|
    apply_discount = cart[cart_item][:clearance]
    if apply_discount == true 
      current_price = cart[cart_item][:price]
      current_price = current_price*discounted_value
      cart[cart_item][:price] = current_price.round(3)
    end
  end
cart 

end #apply_clearance
  
def get_grocery_total(cart)
  sum_total = 0.0
  cart.each do |cart_item, cart_data|
    puts "cart_item = #{cart_item}"
    puts "cart_data = #{cart_data}"
    item_price = cart[cart_item][:price]
    item_count = cart[cart_item][:count]
    sum_total = sum_total + (item_price * item_count)
  end
  sum_total
end


def checkout(cart, coupons)
  
  grocery = consolidate_cart(cart)
  if !coupons == nil
    grocery_wcoupons = apply_coupons(grocery,coupons)
    grocery_wclearance = apply_clearance(grocery_wcoupons)
  else
    grocery_wclearance = apply_clearance(grocery)
  end
  
  
  
  
  
  
end
