@EndUserText.label: 'Projetion view ZDH_I_ORDERHEADER_M'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Metadata.allowExtensions: true
define root view entity ZDH_C_OrderHeader_M
  provider contract transactional_query
  as projection on ZDH_I_OrderHeader_M
{
  key OrderId,
      Description,
      
      @Semantics.amount.currencyCode: 'Currency'
      TotalAmount,
      Currency,
      Status,
      LocalCreatedByUser,
      LocalCreatedAt,
      LocalLastChangedByUser,
      LocalLastChangedAt,
      LastChangedAt,

      /* Associations */
      _OrderItem: redirected to composition child ZDH_C_OrderItem_M
}
