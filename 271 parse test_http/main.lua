require 'EligibilityResponse'
-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)
   body = net.http.parseRequest{data=Data}.body
   body = body:gsub("\29", "*")
   body = body:gsub("\030", "~")
   print("Data: " .. body)
   
   local In,Name,Warnings = x12.parse{vmd='271V2_5010.vmd', data=body}
   print("After Parse: " .. In:S())
   local response = json.parse{data=ELIGIBILITY_RESPONSE}
   local TS
   -- local transactions = In.InterchangeEnvelope.FunctionalGroup[1].TransactionSet:nodeValue()
   for i=1,In.InterchangeEnvelope.IEA[1]:nodeValue() do
      for j=1,In.InterchangeEnvelope.FunctionalGroup[i].GE[1]:nodeValue() do
         TS = In.InterchangeEnvelope.FunctionalGroup[i].TransactionSet[j]
         --find error AAA nodes
         
         
         for a2100 = 1, TS["2000A"][1]["2100A"].AAA:childCount() do --error in 2100A loop
               AddErrorMessage(response, TS["2000A"][1]["2100A"].AAA[a2100][3]:nodeValue(), TS["2000A"][1]["2100A"].AAA[a2100][4]:nodeValue())
            end
         for a2000 = 1, TS["2000A"][1].AAA:childCount() do --error in 2000A loop
            AddErrorMessage(response, TS["2000A"][1].AAA[a2000][3]:nodeValue(), TS["2000A"][1].AAA[a2000][4]:nodeValue())
         end
         --print(TS["2000A"][1]["2100A"].AAA:childCount())
         
         for b2100 = 1, TS["2000B"][1]["2100B"].AAA:childCount() do --error in 2100B loop
            AddErrorMessage(response, TS["2000B"][1]["2100B"].AAA[b2100][3]:nodeValue(), TS["2000B"][1]["2100B"].AAA[b2100][4]:nodeValue())
         end
         --end error handling except for 2110C
         if (TS["2000C"][1]["2100C"].AAA:childCount() > 0) then
            for c2100 = 1, TS["2000C"][1]["2100C"].AAA:childCount() do
               AddErrorMessage(response, TS["2000C"][1]["2100C"].AAA[c2100][3]:nodeValue(), TS["2000C"][1]["2100C"].AAA[c2100][4]:nodeValue())
            end
         else
            -- plan
            local plan = json.parse{data=ELIGIBILITY_PLAN}
            local eligibilityerror = json.parse{data=ELIGIBILITY_ERROR}
            print(TS)
            print("TransactionSet " .. j .. " "  .. TS:S())
            plan.PBMName = TS["2000A"][1]["2100A"].NM1[3]:nodeValue()
            plan.PayerId = TS["2000C"][1]["2100C"].NM1[9]:nodeValue()
            plan.SubscriberTo.SubscriberName.FirstName = TS["2000C"][1]["2100C"].NM1[4]:nodeValue()
            plan.SubscriberTo.SubscriberName.LastName = TS["2000C"][1]["2100C"].NM1[3]:nodeValue()
            plan.SubscriberTo.SubscriberName.MiddleName = TS["2000C"][1]["2100C"].NM1[5]:nodeValue()
            plan.SubscriberTo.SubscriberName.Suffix = TS["2000C"][1]["2100C"].NM1[7]:nodeValue()
            plan.SubscriberTo.SubscriberName.Prefix = TS["2000C"][1]["2100C"].NM1[6]:nodeValue()
            plan.SubscriberTo.SubscriberAddress.AddressLine1 = TS["2000C"][1]["2100C"].N3[1]:nodeValue()
            plan.SubscriberTo.SubscriberAddress.AddressLine2 = TS["2000C"][1]["2100C"].N3[2]:nodeValue()
            plan.SubscriberTo.SubscriberAddress.City = TS["2000C"][1]["2100C"].N4[1]:nodeValue()
            plan.SubscriberTo.SubscriberAddress.StateCode = TS["2000C"][1]["2100C"].N4[2]:nodeValue()
            plan.SubscriberTo.SubscriberAddress.ZipCode = TS["2000C"][1]["2100C"].N4[3]:nodeValue()
            plan.SubscriberTo.SubscriberAddress.Country = TS["2000C"][1]["2100C"].N4[4]:nodeValue()
            plan.SubscriberTo.DateOfBirth = TS["2000C"][1]["2100C"].DMG[2]:nodeValue()
            plan.SubscriberTo.GenderTerm = TS["2000C"][1]["2100C"].DMG[3]:nodeValue()
            --loop through refs of 2100C for cardholderid
            for m=1, TS["2000C"][1]["2100C"].REF:childCount() do
               if (TS["2000C"][1]["2100C"].REF[m][1]:nodeValue() == 'HJ') then
                  plan.CardholderId = TS["2000C"][1]["2100C"].REF[m][2]
               end
            end
            if ((not TS["2000C"][1]["2100C"].REF:isNull()) and (TS["2000C"][1]["2100C"].REF[1] == 'HJ')) then
               
            end
            print(TS["2000C"][1]["2100C"])
            for k=1, TS["2000C"][1]["2100C"]["2110C"]:childCount() do
               --loop through AAA segments and add to error list
               
               for c2110=1, TS["2000C"][1]["2100C"]["2110C"][k].AAA:childCount() do
                  AddErrorMessage(response, TS["2000C"][1]["2100C"]["2110C"][k].AAA[c2110][3]:nodeValue(), TS["2000C"][1]["2100C"]["2110C"][k].AAA[c2110][4]:nodeValue())
               end
               local node2110CEB = TS["2000C"][1]["2100C"]["2110C"][k]:child('EB')
               
               if((not node2110CEB:isNull()) and (node2110CEB[3]:nodeValue() == '30') and (node2110CEB[1]:nodeValue() == '1')) then
                  plan.HealthPlanName = node2110CEB[5]:nodeValue()
               end
               if((not node2110CEB:isNull()) and (node2110CEB[3]:nodeValue() == '88') and (node2110CEB[1]:nodeValue() == '1')) then
                  plan.RetailPharmacyBenefit = 'true'
               end
               if((not node2110CEB:isNull()) and (node2110CEB[3]:nodeValue() == '90') and (node2110CEB[1]:nodeValue() == '1')) then
                  plan.MailOrderPharmacyBenefit = 'true'
               end
               local node2110CREF = TS["2000C"][1]["2100C"]["2110C"][k]:child('REF')
               if(not node2110CREF:isNull()) then
                  if (node2110CREF[1]:nodeValue() == '6P') then
                     plan.GroupNumber = node2110CREF[2]:nodeValue()
                     plan.GroupName = node2110CREF[3]:nodeValue()
                  elseif(node2110CREF[1]:nodeValue() == 'IG') then
                     plan.CopayId = node2110CREF[2]:nodeValue()
                  elseif(node2110CREF[1]:nodeValue() == 'FO') then
                     plan.FormularyId = node2110CREF[2]:nodeValue()
                  elseif(node2110CREF[1]:nodeValue() == 'ALS') then
                     plan.AlternativeId = node2110CREF[2]:nodeValue()
                  elseif(node2110CREF[1]:nodeValue() == 'CLI') then
                     plan.CoverageId = node2110CREF[2]:nodeValue()
                  elseif(node2110CREF[1]:nodeValue() == 'N6') then
                     plan.PlanNetworkId = node2110CREF[2]:nodeValue()
                  elseif(node2110CREF[1]:nodeValue() == '18') then
                     plan.HealthPlanId = node2110CREF[2]:nodeValue()
                  end
               end
               
               
               table.insert(response.EligibilityPlanList, plan)
            end
         end
      end
   end
    
      
  -- response.EligibilityPlanList[1].PBMName = In.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1]["2100A"].NM1[3]
   print(response)
   print("response json " .. json.serialize{data=response})
   net.http.respond{body=json.serialize{data=response}, code=202}
end

function can_resend(code)
   if (code == "C") then return "1" -- correct and resubmit
   elseif (code =="N") then return "0" --resubmission not allowed
   elseif(code=="R") then return "1" -- resubmission allowed
   elseif(code=="P") then return "1" -- resubmission allowed
   elseif(code=="S") then return "0" --do not resubmit, inquiry initiated to a third party
   elseif(code=="W") then return "1" -- wait 30 days and resubmit
   elseif(code=="X") then return "1" -- wait 10 days and resubmit
   elseif(code=="Y") then return "0" -- Do not resubmit
   end
end

function get_rejectreason(code)
   if (code =="15") then return "Required application data missing"
   elseif (code =="04") then return "Authorized Quantity Exceeded"
   elseif (code =="35") then return "Out of Network"
   elseif (code =="41") then return "Authorization/Access Restrictions"
   elseif (code =="42") then return "Unable to Respond at Current Time"
   elseif (code =="43") then return "Invalid/Missing Provider Identification"
   elseif (code =="44") then return "Invalid/Missing Provider Name"
   elseif (code =="45") then return "Invalid/Missing Provider Specialty"
   elseif (code =="46") then return "Invalid/Missing Provider Phone Number"
   elseif (code =="47") then return "Invalid/Missing Provider State"
   elseif (code =="48") then return "Invalid/Missing Referring Provider Identification Number"
   elseif (code =="49") then return "Provider is Not Primary Care Physician"
   elseif (code =="50") then return "Provider Ineligible for Inquiries"
   elseif (code =="51") then return "Provider Not on File"
   elseif (code =="52") then return "Service Dates Not Within Provider Plan Enrollment"
   elseif (code =="56") then return "Inappropriate Date"
   elseif (code =="57") then return "Invalid/Missing Date(s) of Service"
   elseif (code =="58") then return "Invalid/Missing Date-of-Birth"
   elseif (code =="60") then return "Date of Birth Follows Date(s) of Service"
   elseif (code =="61") then return "Date of Death Precedes Date(s) of Service"
   elseif (code =="62") then return "Date of Service Not Within Allowable Inquiry Period"
   elseif (code =="63") then return "Date of Service in Future"
   elseif (code =="71") then return "Patient Birth Date Does Not Match That for the Patient on the Database"
   elseif (code =="72") then return "Invalid/Missing Subscriber/Insured ID"
   elseif (code =="73") then return "Invalid/Missing Subscriber/Insured Name"
   elseif (code =="74") then return "Invalid/Missing Subscriber/Insured Gender Code"
   elseif (code =="75") then return "Subscriber/Insured Not Found"
   elseif (code =="76") then return "Duplicate Subscriber/Insured ID Number"
   elseif (code =="78") then return "Subscriber/Insured Not in Group/Plan Identified"
   elseif (code =="79") then return "Invalid Participant Identification"
   elseif (code =="97") then return "Invalid or Missing Provider Address"
   elseif (code =="T4") then return "Payer Name or Identifier Missing"
   else return "Unknown error code: " .. code
   end
end

function AddErrorMessage(response, rejectreason, resendcode)
   local eligibilityerror = json.parse{data=ELIGIBILITY_ERROR}
   eligibilityerror.CanResend = can_resend(resendcode)
   eligibilityerror.Message = get_rejectreason(rejectreason)
   table.insert(response.EligibilityErrorList, eligibilityerror)
end