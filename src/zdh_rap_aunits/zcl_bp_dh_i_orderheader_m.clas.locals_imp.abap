CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.
    CLASS-DATA:
        my_order_items_active TYPE TABLE FOR READ RESULT zdh_i_orderitem_m.


  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.
    METHODS setheaderdefaultvalues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR order~setheaderdefaultvalues.
    METHODS setitemcurrency FOR DETERMINE ON MODIFY
      IMPORTING keys FOR order~setitemcurrency.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR order RESULT result.
    METHODS copy FOR MODIFY
      IMPORTING keys FOR ACTION order~copy.
    METHODS activate FOR MODIFY
      IMPORTING keys FOR ACTION order~activate.
    METHODS collectlatenumberingkeys FOR DETERMINE ON SAVE
      IMPORTING keys FOR order~collectlatenumberingkeys.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD SetHeaderDefaultValues.

    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY Order
            ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(orders).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
      IF <order>-Description IS INITIAL.
        <order>-Description = |{ cl_abap_context_info=>get_user_technical_name( ) }:{ cl_abap_context_info=>get_system_date( ) } { cl_abap_context_info=>get_system_time( ) } |.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZDH_I_OrderHeader_M IN LOCAL MODE
        ENTITY Order
            UPDATE FIELDS ( Description )
            WITH CORRESPONDING #( orders ).
  ENDMETHOD.

  METHOD SetItemCurrency.

    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY Order
            FIELDS ( Currency ) WITH CORRESPONDING #( keys ) RESULT DATA(orders)
            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(order_items).

    LOOP AT order_items ASSIGNING FIELD-SYMBOL(<item>).
      <item>-Currency = VALUE #( orders[ KEY pid %pid = <item>-%pidparent OrderId = <item>-OrderId ]-Currency DEFAULT <item>-Currency ).
    ENDLOOP.

    MODIFY ENTITIES OF ZDH_I_OrderHeader_M IN LOCAL MODE
        ENTITY OrderItem
            UPDATE FIELDS ( Currency )
            WITH CORRESPONDING #( order_items ).
  ENDMETHOD.

  METHOD get_instance_features.

    result = CORRESPONDING #( keys ).

    LOOP AT result ASSIGNING FIELD-SYMBOL(<feature_result>).
      <feature_result>-%field-TotalAmount   = if_abap_behv=>fc-f-unrestricted.
      <feature_result>-%field-Currency      = if_abap_behv=>fc-f-mandatory.
    ENDLOOP.
  ENDMETHOD.

  METHOD Copy.
    CONSTANTS:
        c_is_draft TYPE if_abap_behv=>t_xflag VALUE if_abap_behv=>mk-on.

    TYPES:
      BEGIN OF ty_cid_map,
        orig_cid TYPE abp_behv_cid,
        new_cid  TYPE abp_behv_cid,
      END OF ty_cid_map,

      tt_cid_map TYPE STANDARD TABLE OF ty_cid_map.

    DATA:
      orders_create    TYPE TABLE FOR CREATE ZDH_I_OrderHeader_M\\Order,
      order_items_cba  TYPE TABLE FOR CREATE ZDH_I_OrderHeader_M\\Order\_OrderItem,

      cid_map          TYPE tt_cid_map,

      order_count      TYPE i,
      order_item_count TYPE i.


    IF lines( keys ) > 1.
      failed-order      = CORRESPONDING #( keys ).
      reported-order    = CORRESPONDING #( keys ).

      LOOP AT reported-order ASSIGNING FIELD-SYMBOL(<repo_order>).
        <repo_order>-%msg = new_message_with_text(
                              severity = if_abap_behv_message=>severity-error
                              text     = `Can Copy onyl 1 at a time!`
                            ).
      ENDLOOP.

      RETURN.
    ENDIF.


    " Get Order header for each item key
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY Order
            ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(orders)
            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(order_items).


    IF Orders IS INITIAL OR order_items IS INITIAL.
      failed-order      = CORRESPONDING #( keys ).
      reported-order    = CORRESPONDING #( keys ).

      LOOP AT reported-order ASSIGNING <repo_order>.
        <repo_order>-%msg = new_message_with_text(
                              severity = if_abap_behv_message=>severity-error
                              text     = `Selected Order/s could not be found!`
                            ).
      ENDLOOP.
      RETURN.
    ENDIF.


    " Prepare payload for new Order create
    LOOP AT orders ASSIGNING FIELD-SYMBOL(<orig_order>).

      order_count += 1.

      INSERT CORRESPONDING #( <orig_order> CHANGING CONTROL ) INTO TABLE orders_create ASSIGNING FIELD-SYMBOL(<order_create>).
      <order_create>-%cid       = |Order__{ order_count }|.
      <order_create>-%is_draft  = c_is_draft.

      " Change description to add "Copy of <Order Number>" as prefix
      <order_create>-Description = |Copy of { <orig_order>-Description }|.

      CLEAR: <order_create>-OrderId, <order_create>-%control-OrderId.

      order_item_count          = 0.

      " Item
      INSERT INITIAL LINE INTO TABLE order_items_cba ASSIGNING FIELD-SYMBOL(<item_cba>).
      <item_cba>-%cid_ref   = <order_create>-%cid.
      <item_cba>-%is_draft  = c_is_draft.

      LOOP AT order_items ASSIGNING FIELD-SYMBOL(<orig_order_item>) USING KEY entity WHERE OrderId = <orig_order>-OrderId.

        order_item_count += 1.

        INSERT CORRESPONDING #( <orig_order_item> CHANGING CONTROL ) INTO TABLE <item_cba>-%target ASSIGNING FIELD-SYMBOL(<item_create>).
        <item_create>-%cid          = |{ <order_create>-%cid }_Item_{ order_item_count }|.
        <item_create>-%is_draft     = c_is_draft.

        CLEAR: <item_create>-OrderId, <item_create>-%control-OrderId.
      ENDLOOP.
    ENDLOOP.

    " Create new orders
    MODIFY ENTITIES OF ZDH_I_OrderHeader_M IN LOCAL MODE
        ENTITY Order
            CREATE FROM orders_create
            CREATE BY \_OrderItem FROM order_items_cba
        FAILED DATA(failed_create)
        REPORTED DATA(reported_create)
        MAPPED DATA(mapped_create).

    " Map to action parameter
    mapped = CORRESPONDING #( DEEP mapped_create ).

    IF mapped-order IS NOT INITIAL.
      mapped-order[ 1 ]-%cid = keys[ 1 ]-%cid.
    ENDIF.

  ENDMETHOD.

  METHOD Activate.
*
*    " map ItemForEdit to ItemNo
*    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
*        ENTITY Order
*            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(order_items_active).
*
*    my_order_items_active = order_items_active.
  ENDMETHOD.

  METHOD CollectLateNumberingKeys.

    " map ItemForEdit to ItemNo
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY Order
            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(order_items_active).

    my_order_items_active = order_items_active.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_orderitem DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS CalculateOrderTotal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItem~CalculateOrderTotal.
    METHODS calculateordertotalondelete FOR DETERMINE ON MODIFY
      IMPORTING keys FOR orderitem~calculateordertotalondelete.
    METHODS SetItemDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItem~SetItemDefaultValues.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR OrderItem RESULT result.

ENDCLASS.

CLASS lhc_orderitem IMPLEMENTATION.

  METHOD CalculateOrderTotal.

    " Get Order header for each item key
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY OrderItem
            BY \_Order ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(orders).

    " Get all existing items for each order
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY Order
            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( orders ) RESULT DATA(order_items).


    " Calculate next item number for each order based on the last item number for that specific order
    LOOP AT order_items ASSIGNING FIELD-SYMBOL(<order_temp>)
        GROUP BY ( %pidparent   = <order_temp>-%pidparent
                   orderId      = <order_temp>-OrderId )
        ASSIGNING FIELD-SYMBOL(<order_group>).

      DATA(total_of_items) = REDUCE #( INIT item_total = 0
                                       FOR <item> IN GROUP <order_group>
                                       NEXT item_total = item_total + ( <item>-Quantity * <item>-NetPrice ) ).

      ASSIGN Orders[ KEY pid %pid = <order_group>-%pidparent OrderId = <order_group>-orderid ] TO FIELD-SYMBOL(<order>).
      IF <order> IS ASSIGNED.
        <order>-TotalAmount = total_of_items.
        UNASSIGN <order>.
      ENDIF.
    ENDLOOP.


    " Update Order Total
    MODIFY ENTITIES OF ZDH_I_OrderHeader_M IN LOCAL MODE
        ENTITY Order
            UPDATE FIELDS ( TotalAmount )
            WITH CORRESPONDING #( Orders ).
  ENDMETHOD.

  METHOD CalculateOrderTotalOnDelete.


    " Get deleted items drafts - READ ENTITIES with the keys will not return any result in this case!
    SELECT
        FROM zdh_t_orderitmmd
        FIELDS draftuuid, parentdraftuuid, orderid, itemno
        FOR ALL ENTRIES IN @keys
        WHERE draftuuid = @keys-%pid
          AND orderid   = @keys-OrderId
          AND itemno    = @keys-ItemNo
        INTO TABLE @DATA(deleted_item_drafts).


    " Read all undeleted items of these Orders now!
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
      ENTITY Order
          ALL FIELDS WITH VALUE #( FOR <deleted_item> IN deleted_item_drafts
                                   ( %is_draft = if_abap_behv=>mk-on
                                     %pid      = <deleted_item>-parentdraftuuid
                                     OrderId   = <deleted_item>-orderid ) )
          RESULT DATA(orders)

          BY \_OrderItem ALL FIELDS WITH VALUE #( FOR <deleted_item> IN deleted_item_drafts
                                                  ( %is_draft = if_abap_behv=>mk-on
                                                    %pid      = <deleted_item>-parentdraftuuid
                                                    OrderId   = <deleted_item>-orderid ) )
          RESULT DATA(order_items).

    " Calculate next item number for each order based on the last item number for that specific order
    LOOP AT order_items ASSIGNING FIELD-SYMBOL(<order_temp>)
        GROUP BY ( %pidparent   = <order_temp>-%pidparent
                   orderId      = <order_temp>-OrderId )
        ASSIGNING FIELD-SYMBOL(<order_group>).

      DATA(total_of_items) = REDUCE #( INIT item_total = 0
                                       FOR <item> IN GROUP <order_group>
                                       NEXT item_total = item_total + ( <item>-Quantity * <item>-NetPrice ) ).

      ASSIGN Orders[ KEY pid %pid = <order_group>-%pidparent OrderId = <order_group>-orderid ] TO FIELD-SYMBOL(<order>).
      IF <order> IS ASSIGNED.
        <order>-TotalAmount = total_of_items.
        UNASSIGN <order>.
      ENDIF.
    ENDLOOP.


    " Update Order Total
    MODIFY ENTITIES OF ZDH_I_OrderHeader_M IN LOCAL MODE
        ENTITY Order
            UPDATE FIELDS ( TotalAmount )
            WITH CORRESPONDING #( Orders ).
  ENDMETHOD.

  METHOD SetItemDefaultValues.

    " Get Order header for each item key
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY OrderItem
            BY \_Order ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(orders).

    " Get all existing items for each order
    READ ENTITIES OF zdh_i_orderheader_m IN LOCAL MODE
        ENTITY Order
            BY \_OrderItem ALL FIELDS WITH CORRESPONDING #( orders ) RESULT DATA(order_items).

    " Calculate next item number for each order based on the last item number for that specific order
    LOOP AT order_items ASSIGNING FIELD-SYMBOL(<order_temp>)
        GROUP BY ( %pidparent   = <order_temp>-%pidparent
                   orderId      = <order_temp>-OrderId )
        ASSIGNING FIELD-SYMBOL(<order_group>).

      LOOP AT GROUP <order_group> ASSIGNING FIELD-SYMBOL(<order_item>).

        " Item currency - form header currency
        <order_item>-Currency = VALUE #( orders[ KEY pid %pid = <order_item>-%pidparent OrderId = <order_item>-OrderId ]-Currency OPTIONAL ).
      ENDLOOP.
    ENDLOOP.


    " Update item_no_foe_edit field for each order
    MODIFY ENTITIES OF ZDH_I_OrderHeader_M IN LOCAL MODE
        ENTITY OrderItem
            UPDATE FIELDS ( Currency )
            WITH CORRESPONDING #( order_items ).
  ENDMETHOD.

  METHOD get_instance_features.

    result = CORRESPONDING #( keys ).

    LOOP AT result ASSIGNING FIELD-SYMBOL(<feature_result>).
      <feature_result>-%field-Currency = if_abap_behv=>fc-f-read_only.

      " In edit scenario, ItemForEdit is readonly
      <feature_result>-%field-ItemNoForEdit = if_abap_behv=>fc-f-read_only.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zdh_i_orderheader_m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_zdh_i_orderheader_m IMPLEMENTATION.

  METHOD adjust_numbers.

    SELECT MAX( order_id ) AS lastOrderId
        FROM zdh_t_order
        INTO @DATA(latest_order_id).

    " map ItemForEdit to ItemNo
    DATA(order_items_active) = lhc_Order=>my_order_items_active.

    LOOP AT mapped-order ASSIGNING FIELD-SYMBOL(<order>).
      latest_order_id += 1.

      " Late numbering - map final number to temporary numbers
      <order>-OrderId = |{ latest_order_id ALPHA = IN }|.

      LOOP AT mapped-orderitem ASSIGNING FIELD-SYMBOL(<order_item>).
        <order_item>-OrderId = <order>-OrderId.

        " Map ItemNo from %TMP to final ItemNo
        <order_item>-ItemNo  = VALUE #( order_items_active[ %pid = <order_item>-%pid ]-ItemNoForEdit OPTIONAL ).
      ENDLOOP.
    ENDLOOP.

    " Adding item to existing order
    LOOP AT mapped-orderitem ASSIGNING <order_item>
       WHERE OrderId IS INITIAL AND ItemNo IS INITIAL.

      <order_item>-OrderId = COND #( WHEN <order_item>-%tmp-OrderId IS NOT INITIAL THEN <order_item>-%tmp-OrderId ELSE '' ).

      " Map ItemNo from %TMP to final ItemNo
      <order_item>-ItemNo  = VALUE #( order_items_active[ %pid = <order_item>-%pid ]-ItemNoForEdit OPTIONAL ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
