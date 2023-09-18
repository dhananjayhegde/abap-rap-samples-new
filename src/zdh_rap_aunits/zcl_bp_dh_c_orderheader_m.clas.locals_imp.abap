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
