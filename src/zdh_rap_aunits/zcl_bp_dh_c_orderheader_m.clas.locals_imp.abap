CLASS lhc_orderitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS augment_cba_Itemattachment FOR MODIFY
      IMPORTING entities FOR CREATE OrderItem\_Itemattachment.

ENDCLASS.

CLASS lhc_orderitem IMPLEMENTATION.

  METHOD augment_cba_Itemattachment.
    CONSTANTS:
        c_is_draft TYPE if_abap_behv=>t_xflag VALUE if_abap_behv=>mk-on.
    DATA:
        order_attach_cba TYPE TABLE FOR CREATE ZDH_I_OrderHeader_M\\OrderItem\_ItemAttachment.

    " Get all existing items for each order
    READ ENTITIES OF zdh_i_orderheader_m
        ENTITY OrderItem
            BY \_ItemAttachment ALL FIELDS WITH CORRESPONDING #( entities ) RESULT DATA(item_attachments).

    " Last item per order/order %PID
    SELECT
        FROM @item_attachments AS items
        FIELDS %pidparent AS pidparent, OrderId, ItemNo, MAX( SeqNum ) AS lastSeqNo
        GROUP BY OrderId, ItemNo, %pidparent
        INTO TABLE @DATA(items_with_last_attach_seqno).


    " Calculate next item number for each order based on the last item number for that specific order
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<attchment_cba_temp>)
        GROUP BY ( %pid     = <attchment_cba_temp>-%pid
                   OrderId  = <attchment_cba_temp>-OrderId
                   ItemNo   = <attchment_cba_temp>-ItemNo )
        ASSIGNING FIELD-SYMBOL(<attachment_cba_group>).

      DATA(order_last_item_no) = VALUE #( items_with_last_attach_seqno[ pidparent = <attachment_cba_group>-%pid
                                                                        OrderId   = <attachment_cba_group>-orderid
                                                                        ItemNo    = <attachment_cba_group>-itemno ]-lastSeqNo DEFAULT 0 ).


      LOOP AT GROUP <attachment_cba_group> ASSIGNING FIELD-SYMBOL(<attachment_cba_orig>).

        INSERT CORRESPONDING #( <attachment_cba_orig> EXCEPT %target ) INTO TABLE order_attach_cba ASSIGNING FIELD-SYMBOL(<attachment_cba>).

        LOOP AT <attachment_cba_orig>-%target ASSIGNING FIELD-SYMBOL(<attachment_target_orig>) WHERE SeqNum IS INITIAL.

          " Item no
          order_last_item_no   += 1.

          INSERT CORRESPONDING #( <attachment_target_orig> ) INTO TABLE <attachment_cba>-%target ASSIGNING FIELD-SYMBOL(<attachment_create>).
          <attachment_create>-SeqNum           = order_last_item_no.
          <attachment_create>-%control-SeqNum  = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.

    ENDLOOP.


    " Augment the CBA payload
    MODIFY AUGMENTING ENTITIES OF ZDH_I_OrderHeader_M
        ENTITY OrderItem
            CREATE BY \_ItemAttachment AUTO FILL CID WITH order_attach_cba.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS augment_cba_Orderitem FOR MODIFY
      IMPORTING entities FOR CREATE Order\_Orderitem.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD augment_cba_Orderitem.
    CONSTANTS:
        c_is_draft TYPE if_abap_behv=>t_xflag VALUE if_abap_behv=>mk-on.
    DATA:
        order_item_cba TYPE TABLE FOR CREATE ZDH_I_OrderHeader_M\\Order\_OrderItem.

    " Get all existing items for each order
    READ ENTITIES OF zdh_i_orderheader_m
        ENTITY Order
            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( entities ) RESULT DATA(order_items).

    " Last item per order/order %PID
    SELECT
        FROM @order_items AS items
        FIELDS %pidparent AS pidparent, OrderId, MAX( ItemNoForEdit ) AS LastItemNo
        GROUP BY ORderId, %pidparent
        INTO TABLE @DATA(orders_w_last_item).


    " Calculate next item number for each order based on the last item number for that specific order
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<item_cba_temp>)
        GROUP BY ( %pid     = <item_cba_temp>-%pid
                   OrderId  = <item_cba_temp>-OrderId )
        ASSIGNING FIELD-SYMBOL(<item_cba_group>).

      DATA(order_last_item_no) = VALUE #( orders_w_last_item[ pidparent = <item_cba_group>-%pid OrderId = <item_cba_group>-orderid ]-lastitemno DEFAULT 0 ).


      LOOP AT GROUP <item_cba_group> ASSIGNING FIELD-SYMBOL(<item_cba_orig>).

        INSERT CORRESPONDING #( <item_cba_orig> EXCEPT %target ) INTO TABLE order_item_cba ASSIGNING FIELD-SYMBOL(<item_cba>).

        LOOP AT <item_cba_orig>-%target ASSIGNING FIELD-SYMBOL(<item_target_orig>) WHERE ItemNoForEdit IS INITIAL.

          " Item no
          order_last_item_no   += 10.

          INSERT CORRESPONDING #( <item_target_orig> ) INTO TABLE <item_cba>-%target ASSIGNING FIELD-SYMBOL(<item_create>).
          <item_create>-ItemNoForEdit           = order_last_item_no.
          <item_create>-%control-ItemNoForEdit  = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.

    ENDLOOP.


    " Augment the CBA payload
    MODIFY AUGMENTING ENTITIES OF ZDH_I_OrderHeader_M
        ENTITY Order
            CREATE BY \_OrderItem AUTO FILL CID WITH order_item_cba.


  ENDMETHOD.

ENDCLASS.
