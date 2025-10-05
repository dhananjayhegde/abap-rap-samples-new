@EndUserText.label: 'Order Item Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true

@UI.headerInfo: {
    typeName: 'Order Item',
    typeNamePlural: 'Order Items',
    title: {
        type: #STANDARD,
        label: 'Order Item',
        value: 'FormattedItemNo'
    },
    description: {
        type: #STANDARD,
        label: 'Description',
        value: 'Description'
    }
}

@UI.selectionVariant: [
    { qualifier: 'svExpensiveItems', text: 'Expensive (sv)', filter: 'ItemIsExpensive EQ X' },
    { qualifier: 'svCheapItems', text: 'Affordable (sv)' }
]

@UI.presentationVariant: [
    { qualifier: 'pvExpensiveItems', text: 'Expensive (pv)', visualizations: [{ type: #AS_LINEITEM, qualifier: 'liExpensiveItems' }] },
    { qualifier: 'pvCheapItems', text: 'Affordable (pv)', visualizations: [{ type: #AS_LINEITEM, qualifier: 'liCheapItems' }] }
]

@UI.selectionPresentationVariant: [
    { id: 'idSPVExpensiveItems', qualifier: 'spvExpesiveItems', selectionVariantQualifier: 'svExpensiveItems', presentationVariantQualifier: 'pvExpensiveItems', text: 'Expensive (spv)' },
    { id: 'idSPVCheapItems', qualifier: 'spvCheapItems', selectionVariantQualifier: 'svCheapItems', presentationVariantQualifier: 'pvCheapItems', text: 'Affordable (spv)' }
]

@OData.hierarchy.recursiveHierarchy: [{entity.name: 'ZDH_I_OrderItemHierarchy'}]
define root view entity ZDH_C_OrderItemTP_2
  provider contract transactional_query
  as projection on ZDH_R_OrderItemTP_2
{

      @UI.selectionField: [{ position: 10 }]
  key OrderId,
  key ItemNo,

      @UI.lineItem: [
        { position: 10, label: 'Hier. Item No' },
        { position: 10, label: 'Hier. Item No', qualifier: 'liExpensiveItems'  },
        { position: 10, label: 'Hier. Item No', qualifier: 'liCheapItems'  },
        { type: #FOR_ACTION, dataAction: 'SetToComplete', position: 10, label: 'Complete', invocationGrouping: #CHANGE_SET }
      ]
      FormattedItemNo,
      ParentItemNo,

      @Search.defaultSearchElement: true
      @UI.lineItem: [
        { position: 20, label : 'Description' },
        { position: 20, label: 'Description (exp)', qualifier: 'liExpensiveItems'  },
        { position: 20, label: 'Description (aff)', qualifier: 'liCheapItems'  }
      ]
      Description,

      @UI.lineItem: [
        { position: 30, label : 'Quantity'  },
        { position: 30, label: 'Quantity (exp)', qualifier: 'liExpensiveItems'  },
        { position: 30, label: 'Quantity (aff)', qualifier: 'liCheapItems'  }
      ]
      Quantity,

      @UI.hidden: true
      OrderUnit,

      @UI.lineItem: [
        { position: 40, label : 'Net Price'  },
        { position: 40, label: 'Net Price (exp)', qualifier: 'liExpensiveItems'  },
        { position: 40, label: 'Net Price (aff)', qualifier: 'liCheapItems'  }
      ]
      NetPrice,

      @UI.hidden: true
      Currency,

      ItemIsExpensive,

      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [
        { position: 50, label : 'Status'  },
        { position: 40, label: 'Status (exp)', qualifier: 'liExpensiveItems'  }
      ]
      @UI.textArrangement: #TEXT_FIRST
      @ObjectModel.text.element: [ 'StatusText' ]
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZDH_C_StatusVH',
              element: 'Status'
          },
          useForValidation: true
      }]
      Status,

      @Semantics.text: true
      _StatusText[1: Language = $session.system_language ].StatusText as StatusText,

      LocalLastChangedByUser,
      LastChangedAt,

      /* Associations */
      // _Header : redirected to parent ZDH_C_OrderHeaderTP,
      _Parent : redirected to ZDH_C_OrderItemTP_2
}
