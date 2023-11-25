@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item'
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZDH_R_OrderItemTP_2
  as select from ZDH_I_OrderItemNode

  // Composition parent
  association        to parent ZDH_R_OrderHeaderTP as _Header     on  _Header.OrderId = $projection.OrderId

  // Hierarchy parent item
  association        to ZDH_R_OrderItemTP_2        as _Parent     on  $projection.OrderId      = _Parent.OrderId
                                                                  and $projection.ParentItemNo = _Parent.ItemNo

  association [1..*] to ZDH_C_StatusVH             as _StatusText on  _StatusText.Status = $projection.Status

{
  key OrderId,
  key ItemNo,
      concat_with_space( concat_with_space( ltrim(OrderId, '0'), '/', 1 ), ltrim(ItemNo, '0'), 1 ) as FormattedItemNo,
      ParentItemNo,
      Description,
      Quantity,
      OrderUnit,
      NetPrice,
      cast( case when NetPrice > 1000 then 'X'
                 else ''
            end as abap_boolean preserving type )                                                  as ItemIsExpensive,
      Currency,
      
      Status,
      
      LocalLastChangedByUser,
      LastChangedAt,

      /* Associations */
      _Header,
      _Parent,
      _StatusText
}
