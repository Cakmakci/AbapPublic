*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 21.03.2022 at 15:15:36
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_V005......................................*
TABLES: ZUBME_V005, *ZUBME_V005. "view work areas
CONTROLS: TCTRL_ZUBME_V005
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZUBME_V005. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZUBME_V005.
* Table for entries selected to show on screen
DATA: BEGIN OF ZUBME_V005_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZUBME_V005.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZUBME_V005_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZUBME_V005_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZUBME_V005.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZUBME_V005_TOTAL.

*.........table declarations:.................................*
TABLES: ZUBME_T005                     .
TABLES: ZUBME_T005T                    .
