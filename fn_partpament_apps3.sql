function fn_partpayment(in_emp_id number, in_emp_date date, in_end_date date, in_amount number, in_earn_prd number)
return number
as
    v_days_diff number(8,2):=0; v_daysratio number(8,2); v_standard_days number(8,2):=0; v_personal_rate number(12,2):=0; v_org_id number;
        v_standard_hours number(8,2):=0; v_daily_rate number(8,2):=0; v_days_in_month number(2):=0;
       
BEGIN
--picks up the difference of the dates
 
     v_days_diff :=abs(trunc(in_emp_date)- trunc(in_end_date))+1;
   
    select abs(trunc(a.start_date)- trunc(a.end_date))+1, org_id into v_days_in_month, v_org_id
    FROM pa_pcf_earningperiod A
    where id=in_earn_prd;
   
    v_personal_rate := fn_personalrate(in_emp_id, in_end_date);
    v_daily_rate := Fn_Daily(in_emp_id,in_emp_date, in_end_date);
   
    v_standard_days := pkg_global_fnts.fn_getemprule(in_emp_id, 'STANDARD_DAYS',in_emp_date);
    v_standard_hours := pkg_global_fnts.fn_getemprule(in_emp_id, 'STANDARD_HOURS',in_emp_date);  
     
    if v_standard_days > 0 and v_standard_hours > 0 then    
        IF v_org_id = 7292 and v_personal_rate = in_amount then
          v_daysratio :=  Fn_PartPayment_IPED(in_emp_date, in_end_date) * v_daily_rate;
        else
          v_daysratio := (v_days_diff/v_days_in_month) * in_amount;
        end if;
    else
          v_daysratio := 0;
    end if;
 
    return  v_daysratio;
 
exception
  When No_Data_Found Then
    return 0;
end fn_partpayment;