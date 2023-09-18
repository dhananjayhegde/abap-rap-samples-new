@EndUserText.label: 'Projection View for Order Item entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@OData.hierarchy.recursiveHierarchy: [{entity.name: 'ZDH_I_OrderItemHierarchy'}]
define root view entity ZDH_C_OrderItemTP
  provider contract transactional_query
  as projection on ZDH_R_OrderItemTP
{
  key OrderId,
  key ItemNo,
      ParentItemNo,
      Description,
      Quantity,
      OrderUnit,
      NetPrice,
      Currency,
      Status,
      /* Associations */
      _Parent
}
