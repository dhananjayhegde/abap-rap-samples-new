@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item'

@AbapCatalog.extensibility: {
  extensible: true,
  elementSuffix: 'ZOI',
  quota: {
    maximumFields: 500,
    maximumBytes: 5000
  },
  allowNewCompositions: true
}

define root view entity ZDH_OM_R_OrderItem
  as select from ZDH_I_OrderItemBasic
{
  key OrderId,
  key ItemNo,
      concat_with_space( concat_with_space( OrderId, '/', 1 ), ItemNo, 1 ) as FormattedItemNo,
      ParentItemNo,
      IsOutline,
      Description,
      Quantity,
      OrderUnit,
      NetPrice,
      Currency,
      cast( case when NetPrice > 1000 then 'X'
                 else ''
            end as abap_boolean preserving type )                          as ItemIsExpensive,
      DeliveryDate,
      Status,
      Attachment,
      MimeType,
      FileName,
      Requestor,
      case Requestor
        when $session.user then 'X'
        else ' ' end                                                       as IsMyItem,
      LocalCreatedByUser,
      LocalCreatedAt,
      LocalLastChangedByUser,
      LocalLastChangedAt,
      LastChangedAt
}
where
  IsOutline is initial
