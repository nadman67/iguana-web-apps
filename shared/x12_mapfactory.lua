require 'node'


-- define a local table to hold all of the references to functions and variables
local function trace(a,b,c,d) return end

local x12_mapfactory = {}

local function template_4010_IE(x12Msg)
   
   --Interchange Envelope Group
   x12Msg.InterchangeEnvelope.ISA[1]='00'
   x12Msg.InterchangeEnvelope.ISA[2]='          '
   x12Msg.InterchangeEnvelope.ISA[3]='01'
   x12Msg.InterchangeEnvelope.ISA[4]='          '
   x12Msg.InterchangeEnvelope.ISA[5]='ZZ'
   x12Msg.InterchangeEnvelope.ISA[6]='345529167      '--*From the POC/PPMS this is the POC/PPMS participant ID as assigned by Surescripts.
   x12Msg.InterchangeEnvelope.ISA[7]='ZZ'
   x12Msg.InterchangeEnvelope.ISA[8]='445483154      '--*From the POC/PPMS this is Surescripts’ participant ID as assigned by Surescripts.
   x12Msg.InterchangeEnvelope.ISA[9]=os.date('%y%m%d')
   Time=os.time()
   x12Msg.InterchangeEnvelope.ISA[10]=os.date('%H%M',Time)
   x12Msg.InterchangeEnvelope.ISA[11]=string.char(31)
   x12Msg.InterchangeEnvelope.ISA[12]='00501'
   x12Msg.InterchangeEnvelope.ISA[13]=math.random(999999999)--interchange control number from mdx
   x12Msg.InterchangeEnvelope.ISA[14]='0'
   x12Msg.InterchangeEnvelope.ISA[15]='T'
   x12Msg.InterchangeEnvelope.ISA[16] = string.char(28)
   
   
   -- IEA Segment -- Interchange Envelope
   x12Msg.InterchangeEnvelope.IEA[1]='1'
   -- ISA and IEA control number must be the same
   x12Msg.InterchangeEnvelope.IEA[2]=x12Msg.InterchangeEnvelope.ISA[13]
   
end

local function template_4010_FG(x12Msg)
   
   -- GS Segment -- Functional Envelope Group
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[1]='HS'
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[2]='1234567'--*From the POC/PPMS this is the POC/PPMS participant ID as assigned by Surescripts.
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[3]='9876543'--*From the POC/PPMS this is Surescripts’ participant ID as assigned by Surescripts.
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[4]=os.date('%Y%m%d')
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[5]=os.date('%H%M',Time)
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[6]=math.random(99999)
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[7]='X'
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[8]='005010X279A1'
   local GSControlNumer=x12Msg.InterchangeEnvelope.FunctionalGroup[1].GS[6]
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GE[1]='1'
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].GE[2]=GSControlNumer
      
end

local function template_4010_TG_270(x12Msg)
   -- ST Segment -- Transaction Envelope Group
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].ST[1]='270'
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].ST[2]=math.random(99999)
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].ST[3] = "005010X279A1"
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].SE[1] = "16" --NOTE!!!! This is a count of all the segments Use this number to indicate the total number of segments included in the transaction set inclusive of the ST and SE segments.
   local STControlNumber=x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].ST[2]
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].SE[2]=STControlNumber
   
   -- ST Segment -- Transaction Envelope Group
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].BHT[1]='0022'
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].BHT[2]='13'
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1].BHT[3]=math.random(99999)
   
end

local function template_4010_PAY_270(x12Msg,hl7Msg)
   
    -- HL Segment -- Payer Header Information 
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.HL[1]='1'
   
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.HL[3]='20'
   
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.HL[4]='1'
  
   
   -- Get payer information from payers module
   local P = require 'payers'
   local payerId = hl7Msg.IN1[3][1]:S()
   local payer = P.getPayerInfo(payerId) 
   
  
   -- NM1 Segment -- Payer Information
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.Loop2100A.NM1[1]=payer.EntityIdentifierCode
   
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.Loop2100A.NM1[2]=EntityTypeQualifier
   
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.Loop2100A.NM1[3]=payer.SourceName
   
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.Loop2100A.NM1[8]=payer.IdCodeQualifier
   
   x12Msg.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]
   ["Position 010"].Grp010ABCD[1].Loop2000A.Loop2100A.NM1[9]=payer.InfoSourcePrimaryId
   
end

local function template_4010_PRV_270(request,body, count)
   -- HL Segment -- Provider Information (2000A)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1].HL[1]= "1"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1].HL[3] = "20"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1].HL[4] = "1"
   count = count + 1
   --NM Segment (2000A)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1]["2100A"].NM1[1] = "2B" --third party administrator IG p. 48
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1]["2100A"].NM1[2] = "2"--non-person entity IG p. 48
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1]["2100A"].NM1[3] = "SURESCRIPTS LLC"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1]["2100A"].NM1[8] = "PI"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000A"][1]["2100A"].NM1[9] = "S00000000000001"
   count = count + 1
   --HL Segment Provider (2000B)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1].HL[1] = "2"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1].HL[2] = "1"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1].HL[3] = "21"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1].HL[4] = "1"
   count = count + 1
   --NM Segment (2100B)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[1] = "1P"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[2] = "1"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[3] = string.upper(body.PrescriberTo.PrescriberName.LastName)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[4] = string.upper(body.PrescriberTo.PrescriberName.FirstName)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[5] = DefaultNilToUpper(body.PrescriberTo.PrescriberName.MiddleName)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[7] = DefaultNilToUpper(body.PrescriberTo.PrescriberName.Suffix)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[8] = "XX"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].NM1[9] = body.PrescriberTo.NationalProviderId
   count = count + 1
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].REF[1] = "EK"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000B"][1]["2100B"].REF[2] = "T00000000020267"
   count = count + 1
end

local function template_4010_SUBR_270(request,body,c)
   
   -- HL Segment -- Subcriber Information (2000C)
   
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1].HL[1] = "3"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1].HL[2] = "2"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1].HL[3] = "22"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1].HL[4] = "0"
   
  
   -- NM1 Segment -- Subscriber Information (2100C)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].NM1[1] = "IL"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].NM1[2] = "1"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].NM1[3] = string.upper(body.SubscriberTo.SubscriberName.LastName)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].NM1[4] = string.upper(body.SubscriberTo.SubscriberName.FirstName)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].NM1[5] = DefaultNilToUpper(body.SubscriberTo.SubscriberName.MiddleName)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].NM1[7] = DefaultNilToUpper(body.SubscriberTo.SubscriberName.Suffix)
  
   --N3 Segment -- Subscriber Information (2100C)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].N3[1] = string.upper(body.SubscriberTo.SubscriberAddress.AddressLine1)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].N3[2] = DefaultNilToUpper(body.SubscriberTo.SubscriberAddress.AddressLine2)
   
   --N4 Segment -- Subscriber Information (2100C)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].N4[1] = DefaultNilToUpper(body.SubscriberTo.SubscriberAddress.City)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].N4[2] = DefaultNilToUpper(body.SubscriberTo.SubscriberAddress.StateCode)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].N4[3] = DefaultNil(body.SubscriberTo.SubscriberAddress.ZipCode)
    -- DMG Segment -- Subscriber Demographic Information (2100C)
   if (body.SubscriberTo.DateOfBirth ~= json.NULL) then
      request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].DMG[1] = "D8"
      local patDOBDate = dateparse.parse(body.SubscriberTo.DateOfBirth, "yyyy-mm-ddwHH:MM:SS")
      request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].DMG[2] = os.date("%Y%m%d", patDOBDate)
      end
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].DMG[3] = MapGender(body.SubscriberTo.GenderTerm)
   
   --DTP Segment --Subscriber Information (2100C)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].DTP[1] = "291"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].DTP[2] = "D8"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"].DTP[3] = os.date("%Y%m%d", dateparse.parse(body.DateOfService, "yyyy-mm-ddwHH:MM:SS"))
   -- EQ Segment -- Subscriber Benefit Plan Information (2110C)
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"]["2110C"][1].EQ[1] = "88"
   request.InterchangeEnvelope.FunctionalGroup[1].TransactionSet[1]["2000C"][1]["2100C"]["2110C"][2].EQ[1] = "90"
end

local function create_4010_270(x12Msg)
   template_4010_IE(x12Msg)
   template_4010_FG(x12Msg)
   template_4010_TG_270(x12Msg)
end

function x12_mapfactory.create(x12MsgType)
   if x12MsgType == '4010-270' then
      local Outx12Msg =x12.message{vmd='270_5050.vmd',name='270_5010'}
      --Populate x12 message
      create_4010_270(Outx12Msg) 
      return Outx12Msg
   end 
end

function x12_mapfactory.populatePP(x12Msg, body, count)   
 --  template_4010_PAY_270(x12Msg,hl7Msg)
   template_4010_PRV_270(x12Msg,body, count)
   return x12Msg 
end

function x12_mapfactory.populateSubscr(request, body,c)     
   template_4010_SUBR_270(request,body,c)
   return request 
end

return x12_mapfactory