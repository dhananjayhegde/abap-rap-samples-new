@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Item Attachment Entity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZDH_I_OrderItemAttachment_M
  as select from ZDH_I_OrderItemAttachmentBasic

  association [1..1] to ZDH_I_OrderHeader_M      as _Order     on  _Order.OrderId = $projection.OrderId

  association        to parent ZDH_I_OrderItem_M as _OrderItem on  _OrderItem.OrderId = $projection.OrderId
                                                               and _OrderItem.ItemNo  = $projection.ItemNo
{
  key OrderId,
  key ItemNo,
  key SeqNum,

      @Semantics.largeObject:{
        mimeType: 'MimeType',
        fileName: 'FileName',
        contentDispositionPreference: #ATTACHMENT
      }
      Attachment,
      MimeType,
      Filename,

      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,
      LastChangedAt,

      /* Associations */
      _Order,
      _OrderItem
}
