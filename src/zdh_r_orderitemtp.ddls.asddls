@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root View for Order Item Entity'
define root view entity ZDH_R_OrderItemTP
  as select from ZDH_I_OrderItemNode

  association to ZDH_R_OrderItemTP as _Parent on  $projection.OrderId      = _Parent.OrderId
                                              and $projection.ParentItemNo = _Parent.ItemNo
{
  key OrderId,
  key ItemNo,
      concat_with_space( concat_with_space( OrderId, '/', 1 ), ItemNo, 1 ) as FormattedItemNo,
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
