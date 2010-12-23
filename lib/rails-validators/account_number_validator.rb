class AccountNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    mod_10(value, record, attribute)
  end
  
  private
  
  def mod_10 ccNumb, record, attribute
    # Created by: David Leppek
    # 
    # Basically, the alorithum takes each digit, from right to left and muliplies each second
    # digit by two. If the multiple is two-digits long (i.e.: 6 * 2 = 12) the two digits of
    # the multiple are then added together for a new number (1 + 2 = 3). You then add up the 
    # string of numbers, both unaltered and new values and get a total sum. This sum is then
    # divided by 10 and the remainder should be zero if it is a valid credit card. Hense the
    # name Mod 10 or Modulus 10.

    valid = "0123456789"  # Valid digits in a credit card number
    len = ccNumb.length   # The length of the submitted cc number
    iCCN = ccNumb.to_i    # integer of ccNumb
    sCCN = ccNumb.to_s    # string of ccNumb
    sCCN = sCCN.strip

    iTotal = 0      # integer total set at zero
    bNum = true     # by default assume it is a number
    bResult = false # by default assume it is NOT a valid cc

    # Determine if the ccNumb is in fact all numbers
    [0..len].each do |j|
      temp = sCCN[j, j + 1]
      bNum = false if !valid.include?(temp)
    end

    # if it is NOT a number, you can either alert to the fact, or just pass a failure
    bResult = false if !bNum

    # Determine if it is the proper length 
    if len == 0 && bResult
      # nothing, field is blank AND passed above # check
      bResult = false;
    else  
      #ccNumb is a number and the proper length - let's see if it is a valid card number
      if len >= 15  
        # 15 or 16 for Amex or V/MC
        [len..0].each do |i| 
          # LOOP throught the digits of the card
          calc = iCCN.to_i % 10   # right most digit
          calc = calc.to_i        # assure it is an integer
          iTotal += calc          # running total of the card number as we loop - Do Nothing to first digit
          i--                     # decrement the count - move to the next digit in the card
          iCCN = iCCN / 10        # subtracts right most digit from ccNumb
          calc = iCCN.to_i % 10   # NEXT right most digit
          calc = calc * 2          # multiply the digit by two

          # Instead of some screwy method of converting 16 to a string and then parsing 1 and 6 and then adding them to make 7,
          # I use a simple switch statement to change the value of calc2 to 7 if 16 is the multiple.

          case calc
          when 10 
            calc = 1    # 5*2=10 & 1+0 = 1
          when 12 
            calc = 3    # 6*2=12 & 1+2 = 3
          when 14 
            calc = 5    # 7*2=14 & 1+4 = 5
          when 16 
            calc = 7    # 8*2=16 & 1+6 = 7
          when 18     
            calc = 9    # 9*2=18 & 1+8 = 9
          else 
            calc = calc # 4*2= 8 &   8 = 8  -same for all lower numbers
          end
          
          iCCN = iCCN / 10  # subtracts right most digit from ccNum
          iTotal += calc  # running total of the card number as we loop
        end

        if (iTotal % 10) ==0  
          # check to see if the sum Mod 10 is zero
          bResult = true  # This IS (or could be) a valid credit card number.
        else
          bResult = false # This could NOT be a valid credit card number
        end
      end
    end

    # change alert to on-page display or other indication as needed.
    if !bResult
      record.errors[attribute] << "is not a valid credit card number"
    end
  end
end

