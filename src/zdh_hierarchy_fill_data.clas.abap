CLASS zdh_hierarchy_fill_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS delete_all.
ENDCLASS.



CLASS zdh_hierarchy_fill_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


    delete_all( ).

    DATA:
      lt_order     TYPE TABLE OF zdh_t_order,
      lt_orderitem TYPE TABLE OF zdh_t_order_item.

    lt_order = VALUE #(
        ( order_id = '0000001234' currency = 'INR' total_amount = 20000 description = 'Test Order 1' status = 'Sent' )
        ( order_id = '0000002345' currency = 'INR' total_amount = 50000 description = 'Test Order 2' status = 'Fulfilled' )
    ).

    data(lv_current_user) = sy-uname.

    lt_orderitem = VALUE #(
        ( order_id = '0000001234' item_no = '00010' description = 'Accessories' isoutline = abap_true status = '02' requestor = lv_current_user )

        ( order_id = '0000001234' item_no = '00020' description = 'I/O Devices' isoutline = abap_true requestor = lv_current_user )
            ( order_id = '0000001234' item_no = '00040' description = 'Headset'   parent_item_no = '00020'    net_price = 5000    currency = 'INR' status = '02' requestor = lv_current_user )
            ( order_id = '0000001234' item_no = '00050' description = 'Mouse'     parent_item_no = '00020'    net_price = 800     currency = 'INR' status = '03' requestor = lv_current_user )
            ( order_id = '0000001234' item_no = '00060' description = 'Keyboard'  parent_item_no = '00020'    net_price = 1500    currency = 'INR' status = '03' requestor = lv_current_user )

        ( order_id = '0000001234' item_no = '00030' description = 'Memory Devices' isoutline = abap_true )
            ( order_id = '0000001234' item_no = '00070' description = 'Hard disk' parent_item_no = '00030'    net_price = 3500    currency = 'INR' status = '04' )
            ( order_id = '0000001234' item_no = '00080' description = 'USB Drive' parent_item_no = '00030'    net_price = 350     currency = 'INR' status = '02' )


        ( order_id = '0000002345' item_no = '00020' description = 'I/O Devices' isoutline = abap_true )
            ( order_id = '0000002345' item_no = '00040' description = 'Headset'   parent_item_no = '00020'    net_price = 5000    currency = 'INR' status = '03' )
            ( order_id = '0000002345' item_no = '00050' description = 'Mouse'     parent_item_no = '00020'    net_price = 800     currency = 'INR' status = '03' )
            ( order_id = '0000002345' item_no = '00060' description = 'Keyboard'  parent_item_no = '00020'    net_price = 1500    currency = 'INR' status = '02' )

        ( order_id = '0000002345' item_no = '00030' description = 'Memory Devices' isoutline = abap_true )
            ( order_id = '0000002345' item_no = '00070' description = 'Hard disk' parent_item_no = '00030'    net_price = 3500    currency = 'INR' status = '09' )
            ( order_id = '0000002345' item_no = '00080' description = 'USB Drive' parent_item_no = '00030'    net_price = 350     currency = 'INR' status = '09' )
            ( order_id = '0000002345' item_no = '00060' description = 'Keyboard'  parent_item_no = '00030'    net_price = 1500    currency = 'INR' status = '02' )
            ( order_id = '0000002345' item_no = '00090' description = 'Keyboard'  parent_item_no = '00030'    net_price = 1500    currency = 'INR' status = '02' )
    ).

    MODIFY zdh_t_order      FROM TABLE @lt_order.
    out->write( |Order Header: { sy-dbcnt } rows modified| ).

    MODIFY zdh_t_order_item FROM TABLE @lt_orderitem.
    out->write( |Order Item: { sy-dbcnt } rows modified| ).
  ENDMETHOD.

  METHOD delete_all.
    DATA:
          lt_orderitem TYPE TABLE OF zdh_t_order_item.

    SELECT * FROM zdh_t_order INTO TABLE @DATA(orders).
    IF sy-subrc = 0.
      DELETE zdh_t_order FROM TABLE @orders.
    ENDIF.

    SELECT * FROM zdh_t_order_item INTO TABLE @DATA(order_items).
    IF sy-subrc = 0.
      DELETE zdh_t_order_item FROM TABLE @order_items.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
