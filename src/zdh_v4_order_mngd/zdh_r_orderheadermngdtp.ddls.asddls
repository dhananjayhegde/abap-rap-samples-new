@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Header'
define root view entity ZDH_R_OrderHeaderMngdTP
  as select from ZDH_I_OrderBasic
  composition [0..*] of ZDH_R_OrderItemMngdTP as _Item
{
  key OrderId,
      Description,
      TotalAmount,
      Currency,
      Status,

      @Semantics.user.createdBy: true
      LocalCreatedByUser,

      @Semantics.systemDateTime.createdAt: true
      LocalCreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      LocalLastChangedByUser,
      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LocalLastChangedAt,

      @Semantics.systemDateTime.lastChangedAt: true
      LastChangedAt,

      /* Compositions */
      _Item
}
