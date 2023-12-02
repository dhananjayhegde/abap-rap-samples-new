@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item'
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZDH_R_OrderItemMngdTP
  as select from ZDH_I_OrderItemBasic

  // Composition parent
  association to parent ZDH_R_OrderHeaderMngdTP as _Header     on  _Header.OrderId = $projection.OrderId

  // Hierarchy parent item
  association to ZDH_R_OrderItemMngdTP          as _ParentItem on  $projection.OrderId      = _ParentItem.OrderId
                                                               and $projection.ParentItemNo = _ParentItem.ItemNo
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
      LocalLastChangedByUser,
      LastChangedAt,

      /* Associations */
      _Header,
      _ParentItem
}
