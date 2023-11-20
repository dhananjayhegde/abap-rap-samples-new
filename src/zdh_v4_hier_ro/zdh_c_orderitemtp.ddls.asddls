@EndUserText.label: 'Projection View for Order Item entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@OData.hierarchy.recursiveHierarchy: [{entity.name: 'ZDH_I_OrderItemHierarchy'}]
define root view entity ZDH_C_OrderItemTP
  provider contract transactional_query
  as projection on ZDH_R_OrderItemTP
{
  key OrderId,
  key ItemNo,
      
      @UI.lineItem: [{ position: 10, label: 'Hier. Item No' }]
      FormattedItemNo,
      ParentItemNo,
      
      @UI.lineItem: [{ position: 20, label : 'Description' }]
      Description,
      
      @UI.lineItem: [{ position: 30, label : 'Quantity'  }]
      Quantity,
      
      @UI.hidden: true
      OrderUnit,
      
      @UI.lineItem: [{ position: 40, label : 'Net Price'  }]
      NetPrice,
      
      @UI.hidden: true
      Currency,
      
      @UI.lineItem: [{ position: 50, label : 'Status'  }]
      Status,
      
      
      /* Associations */
      _Parent: redirected to ZDH_C_OrderItemTP
}
