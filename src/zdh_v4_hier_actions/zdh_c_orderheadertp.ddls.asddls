@EndUserText.label: 'Order Header Projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZDH_C_OrderHeaderTP
  provider contract transactional_query
  as projection on ZDH_R_OrderHeaderTP
{
  key OrderId,
      Description,
      TotalAmount,
      Currency,
      Status,
      LocalCreatedByUser,
      LocalCreatedAt,
      LocalLastChangedByUser,
      LocalLastChangedAt,
      LastChangedAt,
      
      /* Associations */
      _Item: redirected to composition child ZDH_C_OrderItemTP_2
}
