@EndUserText.label: 'Order Item Attachment Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZDH_C_OrderItemAttachment_M
  as projection on ZDH_I_OrderItemAttachment_M
{
  key OrderId,
  key ItemNo,
  key SeqNum,
      Attachment,
      MimeType,
      Filename,

      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      /* Associations */
      _Order     : redirected to ZDH_C_OrderHeader_M,
      _OrderItem : redirected to parent ZDH_C_OrderItem_M
}
