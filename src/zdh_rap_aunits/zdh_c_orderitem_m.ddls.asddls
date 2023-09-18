@EndUserText.label: 'Projetion view ZDH_I_OrderItem_M'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZDH_C_OrderItem_M
  as projection on ZDH_I_OrderItem_M
{
  key OrderId,
  key ItemNo,
      ItemNoForEdit,
      ParentItemNo,
      IsOutline,
      Description,
      Quantity,
      OrderUnit,
      NetPrice,
      Currency,
      Status,
      LocalCreatedByUser,
      LocalCreatedAt,
      LocalLastChangedByUser,
      LocalLastChangedAt,
      LastChangedAt,
      
      /* Associations */
      _Order : redirected to parent ZDH_C_OrderHeader_M
}
