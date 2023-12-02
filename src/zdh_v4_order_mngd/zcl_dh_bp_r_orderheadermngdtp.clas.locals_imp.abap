CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDescription FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~setDescription.

    METHODS checkQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~checkQuantity.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD setDescription.

    DATA:
        lt_item_update TYPE TABLE FOR UPDATE ZDH_R_OrderHeaderMngdTP\\Item.

    READ ENTITIES OF ZDH_R_OrderHeaderMngdTP IN LOCAL MODE
        ENTITY Item
            ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_item).

    lt_item_update = CORRESPONDING #( lt_item ).

    LOOP AT lt_item_update ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-ParentItemNo IS INITIAL.
        <fs_item>-Description = |{ <fs_item>-ItemNo ALPHA = OUT }|.
      ELSE.
        <fs_item>-Description = |{ <fs_item>-ParentItemNo ALPHA = OUT } >> { <fs_item>-ItemNo ALPHA = OUT }|.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZDH_R_OrderHeaderMngdTP IN LOCAL MODE
        ENTITY item
            UPDATE FIELDS ( Description ) WITH lt_item_update.

  ENDMETHOD.

  METHOD checkQuantity.

    READ ENTITIES OF ZDH_R_OrderHeaderMngdTP IN LOCAL MODE
        ENTITY Item
            ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(lt_item).


    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).

      INSERT INITIAL LINE INTO TABLE reported-item ASSIGNING FIELD-SYMBOL(<reported>).
      <reported>-%key = CORRESPONDING #( <fs_item> ).
      <reported>-%state_area = `CHECK_QTY`.

      IF <fs_item>-Quantity > 1000.

        INSERT INITIAL LINE INTO TABLE reported-item ASSIGNING <reported>.
        <reported>-%key = CORRESPONDING #( <fs_item> ).
        <reported>-%state_area = `CHECK_QTY`.

        <reported>-%msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text     = `Quantity greater than allowed limit, reduce and add more items`
                          ).

        INSERT INITIAL LINE INTO TABLE failed-item ASSIGNING FIELD-SYMBOL(<failed>).
        <failed>-%key = CORRESPONDING #( <fs_item> ).

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Order RESULT result.

ENDCLASS.

CLASS lhc_Order IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
