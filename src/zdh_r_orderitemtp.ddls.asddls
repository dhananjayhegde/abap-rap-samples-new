@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View for Order Item Entity'
define root view entity ZDH_R_OrderItemTP
  as select from ZDH_I_OrderItemNode
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
