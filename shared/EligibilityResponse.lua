ELIGIBILITY_RESPONSE = [[
{
	"EligibilityPlanList" : [
        ],
	"EligibilityErrorList" : [
	],
	"PrescriberTo" : null,
	"SubscriberTo" : null,
	"DateOfService" : null,
	"TransferObjectBusinessCommandEK" : "00000000-0000-0000-0000-000000000000",
	"TransferObjectTransactionTimePoint" : null,
	"ResponsePatientContexts" : null,
	"RequestPatientContexts" : null
}


]]

ELIGIBILITY_ERROR = [[

{
"Message" : null,
"CanResend" : null
}
]]

ELIGIBILITY_PLAN = [[
{
			"PBMName" : null,
			"HealthPlanName" : null,
			"PayerId" : null,
			"MemberId" : null,
			"GroupNumber" : null,
                        "GroupName": null,
			"CardholderId" : null,
			"FormularyId" : null,
			"AlternativeId" : null,
			"CoverageId" : null,
			"CopayId" : null,
                        "PlanNetworkId" : null,
                        "HealthPlanId" : null,
			"SubscriberTo" : {
				"SubscriberName" : {
					"FirstName" : null,
					"LastName" : null,
					"MiddleName" : null,
					"Suffix" : null,
                                        "Prefix" : null
				},
				"SubscriberAddress" : {
					"StateCode" : null,
					"City" : null,
					"ZipCode" : null,
					"Country" : null,
					"AddressLine1" : null,
					"AddressLine2" : null
				},
				"DateOfBirth" : "",
				"GenderTerm" : null,
				"IsDependent" : null
			},
			"PharmacyCoverage" : null,
			"RetailPharmacyBenefit" : null,
			"MailOrderPharmacyBenefit" : null,
			"LongTermCarePharmacyBenefit" : null,
			"SpecialtyPharmacyBenefit" : null,
			"EligibilityErrorList" : []
		}
]]