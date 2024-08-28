@EndUserText.label: 'Order Item Review'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true


@UI: { headerInfo: {
                typeName: 'Review',
                typeNamePlural: 'Reviews',
                title: { type: #STANDARD, value: 'ReviewId' }
              },
  presentationVariant: [{
      sortOrder: [{ by: 'LocalCreatedAt', direction: #DESC }],
      visualizations: [{type: #AS_LINEITEM}]
    }]
}

define view entity ZDH_C_OrderItemReviewTP
  as projection on ZDH_R_OrderItemReviewTP
{
      @UI.facet: [
        {
          id:            'Review',
          purpose:       #STANDARD,
          type:          #IDENTIFICATION_REFERENCE,
          label:         'Review',
          position:      10
        },
        {
          id:            'HelpfulID',
          purpose:       #HEADER,
          type:          #DATAPOINT_REFERENCE,
          label:         'Helpful',
          position:      10,
          targetQualifier: 'HelpfulCount'
        }
      ]

      @UI.hidden: true
  key OrderId,
      @UI.hidden: true
  key ItemNo,
      @UI.hidden: true
  key ReviewId,

      @UI:{
        dataPoint: {
          title: 'Rating'
          ,visualization: #RATING
          ,targetValue: 5
        },
        lineItem:
          [
            {
              position: 10,
              label: 'Rating',
              importance: #HIGH
              ,valueQualifier: 'Rating'
              ,type: #AS_DATAPOINT
            }
          ],
        identification: [
            {
              position: 10,
              label: 'Rating',
              importance: #HIGH
              ,type: #AS_DATAPOINT
            }
          ]
      }
      Rating,

      @UI.lineItem: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      @UI.multiLineText: true
      FreeTextComment,

      @UI:{
        dataPoint: {
          title: 'Helpful',
          targetValueElement: 'HelpfulTotal'
          ,visualization: #PROGRESS
        },
        lineItem: [
            {
              position: 50,
              label: 'Helpful',
              importance: #HIGH
              ,type: #AS_DATAPOINT
              ,valueQualifier: 'Progress'
            }
          ]
      }
      HelpfulCount,

      @UI.hidden: true
      HelpfulTotal,

      @UI.lineItem:       [ { position: 3 } ]
      @UI.identification: [ { position: 3 } ]
      Reviewer,

      @UI.hidden: true
      LocalCreatedAt,

      @UI.hidden: true
      LocalLastChangedAt,

      /* Associations */
      _OrderItem : redirected to ZDH_OM_C_OrderItem
}
