@EndUserText.label: 'Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI.selectionVariant: [
    { qualifier: 'svMyItems', text: 'My Items (sv)', filter: 'IsMyItem EQ X' },
    { qualifier: 'svAllItems', text: 'All Items (sv)' },    
    
    { qualifier: 'svExpesniveItems', text: 'Excess (sv)', filter: 'ItemIsExpensive EQ X' },
    { qualifier: 'svCheapItems', text: 'Aged (sv)' }
]
@UI.presentationVariant: [
    { qualifier: 'pvMyItems', text: 'My Items (pv)', visualizations: [{ type: #AS_LINEITEM, qualifier: 'liMyItems' }] },
    { qualifier: 'pvAllItems', text: 'All Items (pv)', visualizations: [{ type: #AS_LINEITEM, qualifier: 'liAllItems' }] }
]

@UI.selectionPresentationVariant: [
    { id: 'idSPVMyItems', qualifier: 'spvMyItems', selectionVariantQualifier: 'svMyItems', presentationVariantQualifier: 'pvMyItems', text: 'My Items (spv)' },
    { id: 'idSPVAllItems', qualifier: 'spvAllItems', selectionVariantQualifier: 'svAllItems', presentationVariantQualifier: 'pvAllItems', text: 'All Items (spv)' }
]

define root view entity ZDH_OM_C_OrderItem
  provider contract transactional_query
  as projection on ZDH_OM_R_OrderItem
{
  
  
  @UI.lineItem: [
    { position: 10, type: #FOR_ACTION, dataAction: 'CancelOrder', qualifier: 'liMyItems', label: 'Cancel', invocationGrouping: #CHANGE_SET },
    { position: 10, type: #FOR_ACTION, dataAction: 'CancelOrder', qualifier: 'liAllItems', label: 'Cancel', invocationGrouping: #CHANGE_SET },
    
    { position: 10, type: #FOR_ACTION, dataAction: 'KeepOrder', qualifier: 'liMyItems', label: 'Keep', invocationGrouping: #CHANGE_SET },
    { position: 10, type: #FOR_ACTION, dataAction: 'KeepOrder', qualifier: 'liAllItems', label: 'Keep', invocationGrouping: #CHANGE_SET },
    
    { position: 10, type: #FOR_ACTION, dataAction: 'RescheduleDelivery', qualifier: 'liMyItems', label: 'Reschedule Delivery', invocationGrouping: #CHANGE_SET },
    { position: 10, type: #FOR_ACTION, dataAction: 'RescheduleDelivery', qualifier: 'liAllItems', label: 'Reschedule Delivery', invocationGrouping: #CHANGE_SET }
    
  ]
  
  @UI.selectionField: [{ position: 10 }]
  key OrderId,
  key ItemNo,
      
      @UI.lineItem: [
        { position: 10, label: 'Item No.' },
        { position: 10, label: 'Item No.', qualifier: 'liMyItems'  },
        { position: 10, label: 'Item No.', qualifier: 'liAllItems'  }
      ]
      FormattedItemNo,
      ParentItemNo,
      
      @UI.lineItem: [
        { position: 20, label : 'Description' },
        { position: 20, label: 'Description (exp)', qualifier: 'liMyItems'  },
        { position: 20, label: 'Description (aff)', qualifier: 'liAllItems'  }
      ]
      Description,
      
      @UI.lineItem: [
        { position: 30, label : 'Quantity'  },
        { position: 30, label: 'Quantity (exp)', qualifier: 'liMyItems'  },
        { position: 30, label: 'Quantity (aff)', qualifier: 'liAllItems'  }
      ]
      Quantity,
      
      @UI.hidden: true
      OrderUnit,
      
      @UI.lineItem: [
        { position: 40, label : 'Net Price'  },
        { position: 40, label: 'Net Price (exp)', qualifier: 'liMyItems'  },
        { position: 40, label: 'Net Price (aff)', qualifier: 'liAllItems'  }
      ]
      NetPrice,
      
      ItemIsExpensive,
      
      @UI.hidden: true
      Currency,
      
      @UI.lineItem: [
        { position: 45, label : 'Delivery Date', qualifier: 'liMyItems'  },
        { position: 45, label: 'Delivery Date', qualifier: 'liMyItems'  }
      ]      
      DeliveryDate,
      
      
      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [
        { position: 50, label : 'Status'  },        
        { position: 40, label: 'Status (exp)', qualifier: 'liMyItems'  }
      ]
      Status,
      
      @UI.selectionField: [{ position: 30 }]      
      @UI.lineItem: [
        { position: 60, label : 'Requestor'  },
        { position: 60, label: 'Requestor', qualifier: 'liMyItems'  },
        { position: 60, label: 'Requestor', qualifier: 'liAllItems'  }
      ]
      Requestor,
      IsMyItem,
      
      LocalLastChangedByUser,
      LastChangedAt
}
