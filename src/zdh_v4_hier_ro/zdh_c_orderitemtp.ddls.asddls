@EndUserText.label: 'Projection View for Order Item entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED

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

define root view entity ZDH_C_OrderItemTP
  provider contract transactional_query
  as projection on ZDH_R_OrderItemTP
{
  key OrderId,
  key ItemNo,
      
      @UI.lineItem: [
        { position: 10, label: 'Hier. Item No' },
        { position: 10, label: 'Hier. Item No', qualifier: 'liExpensiveItems'  },
        { position: 10, label: 'Hier. Item No', qualifier: 'liCheapItems'  }
      ]
      FormattedItemNo,
      ParentItemNo,
      
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
      
      ItemIsExpensive,
      
      @UI.hidden: true
      Currency,
      
      @UI.lineItem: [
        { position: 50, label : 'Status'  },        
        { position: 40, label: 'Status (exp)', qualifier: 'liExpensiveItems'  }
      ]
      Status,
      
      LocalLastChangedByUser,
      LastChangedAt,
      
      
      /* Associations */
      _Parent: redirected to ZDH_C_OrderItemTP
}
