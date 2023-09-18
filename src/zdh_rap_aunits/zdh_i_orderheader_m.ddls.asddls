@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Header'
define root view entity ZDH_I_OrderHeader_M
  as select from ZDH_I_OrderBasic
  composition [0..*] of ZDH_I_OrderItem_M as _OrderItem
{
  key OrderId,
      Description,
      TotalAmount,
      Currency,
      Status,

      //Admin fields
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
      
      _OrderItem // Make association public
}
