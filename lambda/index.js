console.log('Loading event');
var AWS = require('aws-sdk');
var dynamodb = new AWS.DynamoDB({apiVersion: '2012-08-10'});

exports.handler = function(event, context) {
    var tableName = "bodypart";
    dynamodb.scan({
        TableName : tableName,
        Limit : 10
    }, 
    function(err, data) {
        if (err) {
            context.done('error','reading dynamodb failed: '+err);
        }
        context.succeed(data);
    })
};