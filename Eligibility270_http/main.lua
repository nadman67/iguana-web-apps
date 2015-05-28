require "DefaultValues"
require "fuzzyparser"
require "node"
-- The main function is the first function called from Iguana.
-- The Data argument will contain the message to be processed.
function main(Data)
   local jsonIn = net.http.parseRequest{data = Data}
   local body = json.parse{data=jsonIn.body}
  
   local x12Message = require 'x12_mapfactory'
   local segmentcount = 2
   local request = x12Message.create('4010-270', segmentcount)
   --populate provider
   request = x12Message.populatePP(request, body, segmentcount)
   
   --populate subscriber
   request = x12Message.populateSubscr(request, body, 1)
   local Out = tostring(request)
   Out = Out:gsub("[|][\r]", "\r")
   Out = Out:gsub("\\X1F\\", string.char(31))
   Out = Out:gsub("\\X1C\\", string.char(29))
   Out = Out:gsub("|", "*")
   print(Out)
   net.http.respond{body="", code=202}
end

function MapGender(ek)
   if (ek == "100BDA23-A24B-48E9-A636-DE5A4E90733A") then
      return "F"
   elseif (ek == "C814E143-67D3-4A8D-BE20-BAFF2689E81B") then
      return "M"
   elseif (ek == "9A7DC5CD-24A3-419E-97CB-8198AF588054") then
      return "U"
   else return "U"
   end
end