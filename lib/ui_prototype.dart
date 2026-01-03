import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/clients_repo.dart';
import 'data/org_settings_repo.dart';
import 'data/quotes_repo.dart';

part 'ui_prototype/app.dart';
part 'ui_prototype/shell.dart';
part 'ui_prototype/utils.dart';
part 'ui_prototype/clients_page.dart';
part 'ui_prototype/client_editor_page.dart';
part 'ui_prototype/client_editor_helpers.dart';
part 'ui_prototype/client_detail_page.dart';
part 'ui_prototype/quotes_page.dart';
part 'ui_prototype/quote_wizard_page.dart';
part 'ui_prototype/quote_editor_models.dart';
part 'ui_prototype/quote_editor_page.dart';
part 'ui_prototype/quote_editor_data_mixin.dart';
part 'ui_prototype/quote_editor_build_mixin.dart';
part 'ui_prototype/quote_editor_sections_mixin.dart';
part 'ui_prototype/quote_editor_items_mixin.dart';
part 'ui_prototype/quote_editor_item_cards_mixin.dart';
part 'ui_prototype/quote_editor_ui_helpers.dart';
part 'ui_prototype/quote_edit_item_dialog.dart';
part 'ui_prototype/settings_page.dart';
part 'ui_prototype/settings_sections_mixin.dart';
part 'ui_prototype/settings_models.dart';
