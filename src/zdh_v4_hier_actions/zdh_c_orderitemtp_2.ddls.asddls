@EndUserText.label: 'Order Item Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true

@OData.hierarchy.recursiveHierarchy: [{entity.name: 'ZDH_I_OrderItemHierarchy'}]
define view entity ZDH_C_OrderItemTP_2
  as projection on ZDH_R_OrderItemTP_2
{
      
      @UI.selectionField: [{ position: 10 }]
  key OrderId,
  key ItemNo,

      @UI.lineItem: [
        { position: 10, label: 'Hier. Item No' },
        { type: #FOR_ACTION, dataAction: 'SetToComplete', position: 10, label: 'Complete', invocationGrouping: #CHANGE_SET }
      ]
      FormattedItemNo,
      ParentItemNo,

      @Search.defaultSearchElement: true
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

      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 50, label : 'Status'  }]
      Status,

      LocalLastChangedByUser,
      LastChangedAt,

      /* Associations */
      _Header : redirected to parent ZDH_C_OrderHeaderTP,
      _Parent : redirected to ZDH_C_OrderItemTP_2
}
