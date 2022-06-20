*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 07.01.2022 at 09:59:33
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZUBME_T002......................................*
DATA:  BEGIN OF STATUS_ZUBME_T002                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBME_T002                    .
CONTROLS: TCTRL_ZUBME_T002
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBME_T002                    .
TABLES: ZUBME_T002                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
