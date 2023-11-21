@EndUserText.label: 'Order Header Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
    typeName: 'Order',
    typeNamePlural: 'Orders',
    title.value: 'OrderId',
    description: {
        value: 'Description'
    }
}

@Search.searchable: true

define root view entity ZDH_C_OrderHeaderDirTP
  provider contract transactional_query
  as projection on ZDH_R_OrderHeaderDirTP
{
      
      @UI.facet: [
        { id: 'generalinfoColl', position: 10, label: 'General Info', type: #COLLECTION },
            { id: 'basicDataRef', position: 10, label: 'Basic Data', type: #IDENTIFICATION_REFERENCE, parentId: 'generalinfoColl' },
            { id: 'adminFieldGrpRef', position: 20, label: 'Administrative', type: #FIELDGROUP_REFERENCE, parentId: 'generalinfoColl', targetQualifier: 'adminFieldGrp' },
        
        { id: 'itemColl', position: 20, label: 'Items Hierarchy', type: #LINEITEM_REFERENCE, targetElement: '_Item' }
      ]
      
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10, label : 'Order' }]
      @UI.identification: [{ position: 10, label : 'Order' }]
  key OrderId,

      @Search.defaultSearchElement: true
      @UI.lineItem: [{ position: 20, label : 'Description' }]
      @UI.identification: [{ position: 20, label : 'Description' }]
      Description,

      @UI.lineItem: [{ position: 30, label : 'Total Amount'  }]
      @UI.identification: [{ position: 30, label : 'Total Amount'  }]
      TotalAmount,

      @UI.hidden: true
      Currency,

      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 40, label : 'Status'  }]
      @UI.identification: [{ position: 40, label : 'Status'  }]
      Status,
      
      @UI.fieldGroup: [{ position: 10, label : 'Created By', qualifier: 'adminFieldGrp'  }]
      LocalCreatedByUser,
      
      @UI.fieldGroup: [{ position: 20, label : 'Created At', qualifier: 'adminFieldGrp'  }]
      LocalCreatedAt,
      
      @UI.fieldGroup: [{ position: 30, label : 'Changed By', qualifier: 'adminFieldGrp'  }]
      LocalLastChangedByUser,
      
      @UI.fieldGroup: [{ position: 40, label : 'Changed At', qualifier: 'adminFieldGrp'  }]
      LocalLastChangedAt,
      LastChangedAt,

      /* Associations */
      _Item : redirected to composition child ZDH_C_OrderItemDirTP
}
