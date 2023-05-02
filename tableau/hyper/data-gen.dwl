%dw 2.0
output application/csv quoteHeader=true, quoteValues=true, header=false
var hostPartner = "Space Enterprise"
var partnerConfigs = [
    {
        name: "Earth Retailer",    
        inbound: {
            direction: "INBOUND",
        	receiveEndpoint: "SFTP",
	        formatType: 'X12',
	        targetEndpoint: "HTTP",
	        sourceDocTypes: ["X12-4010-850", "X12-4010-860"],
	        tagetDocType: "Orders-JSON"
        },
        outbound: {
            from: hostPartner,
            to: "Earth Retailer",
            direction: "OUTBOUND",
        	receiveEndpoint: "HTTP",
	        formatType: 'X12',
	        targetEndpoint: "SFTP",
	        sourceDocTypes: ["Invoice-JSON","Invoice-JSON"],
	        tagetDocType: "X12-4010-810"
        }
    },
    {
        name: "Mars Sports",
        inbound: {
            direction: "INBOUND",
        	receiveEndpoint: "SFTP",
	        formatType: 'XML',
	        targetEndpoint: "HTTP",
	        sourceDocTypes: ["Orders-XML", "Orders-Adj"],
	        tagetDocType: "Orders-JSON"
        },
        outbound: {
            from: hostPartner,
            to: "Mars Sports",
            direction: "OUTBOUND",
        	receiveEndpoint: "SFTP",
	        formatType: 'XML',
	        targetEndpoint: "HTTP",
	        sourceDocTypes: ["Invoice-JSON","Invoice-JSON"],
	        tagetDocType: "Invoice-XML"
        }
    },
    {
        name: "Mercury Aerobics",
        inbound: {
            direction: "INBOUND",
        	receiveEndpoint: "AS2",
	        formatType: 'X12',
    	    targetEndpoint: "HTTP",
        	sourceDocTypes: ["X12-4010-850", "X12-4010-860"],
	        tagetDocType: "Orders-JSON"
	   	},
        outbound: {
            from: hostPartner,
            to: "Mercury Aerobics",
            direction: "OUTBOUND",
        	receiveEndpoint: "HTTP",
	        formatType: 'X12',
	        targetEndpoint: "AS2",
	        sourceDocTypes: ["Invoice-JSON","Invoice-JSON"],
	        tagetDocType: "X12-4010-810"
        }
    },
    {
        name: "Sun Systems",
        inbound: {
            direction: "INBOUND",
        	receiveEndpoint: "HTTP",
	        formatType: 'X12',
    	    targetEndpoint: "HTTP",
       		sourceDocTypes: ["X12-4010-850", "X12-4010-860"],
	        tagetDocType: "Orders-JSON"
    	},
        outbound: {
            from: hostPartner,
            to: "Sun Systems",
            direction: "OUTBOUND",
        	receiveEndpoint: "HTTP",
	        formatType: 'X12',
	        targetEndpoint: "HTTP",
	        sourceDocTypes: ["Invoice-JSON","Invoice-JSON"],
	        tagetDocType: "X12-4010-810"
        }
    }
]
var daysBack:Number =  365 * 3
---
(1 to 5000) map (cnt, idx) -> do {
    var partner = partnerConfigs[randomInt(4)]
    var transmission = if( mod(cnt,2) == 0 ) partner.inbound else partner.outbound
    var srcDoc = transmission.sourceDocTypes[randomInt(2)]
    ---    
    {
    "Transmission Id": uuid(),
    "Direction": transmission.direction, 
    "Status": if( mod(cnt,10) == 0) 'ERRORED' else 'DELIVERED',
    "Partner From": transmission.from default partner.name,
    "Partner To": transmission.to default hostPartner,
    "Format Type": transmission.formatType,
    "Date Received": ((now() >> "UTC") - ("P$(randomInt(daysBack))D" as Period)) as String {format: "uuuu-MM-dd'T'HH:mm:ssX"},
    "Received Endpoint": transmission.receiveEndpoint,
    "Target Endpoint": transmission.targetEndpoint ,
    "Message Count": randomInt(100), 
    "Source Doc Type": srcDoc,
    "Target Doc Type": transmission.tagetDocType
    }
    // {
    //     "sourceDocType": {
    //         "baseType": srcDoc,
    //         "name":srcDoc 
    //     },
    //     "targetDocType": {
    //         "baseType": transmission.tagetDocType,
    //         "name": transmission.tagetDocType,
    //     },
    //     "targetEndpoint": {
    //         "endpointType": transmission.targetEndpoint,
    //     },
    //     "partnerFrom": {
    //         "name": partner.name,
    //         "status": 'ACTIVE'
    //     },
    //     "partnerTo": {
    //         "name": hostPartner,
    //         "status":'ACTIVE'
    //     },
    //     "id": uuid(),
    //     "status": if( mod(cnt,10) == 0) 'ERRORED' else 'DELIVERED',
    //     "dateReceived": ((now() >> "UTC") - ("P$(randomInt(daysBack))D" as Period)) as String {format: "uuuu-MM-dd'T'HH:mm:ssX"},
    //     "direction": transmission.direction,
    //     "formatType": transmission.formatType,
    //     "messageCount": randomInt(100),
    //     "receivingEndpointType":transmission.receiveEndpoint
    // }
}