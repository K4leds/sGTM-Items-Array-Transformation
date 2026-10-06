___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "sGTM Items Array Transformation",
  "categories": ["UTILITY", "ANALYTICS", "TAG_MANAGEMENT"],
  "description": "Transform the GA4 items array in server-side GTM. Keep or drop whole items, add/drop/replace parameters conditionally, find-and-replace values (with regex), rename keys, enforce data types, and append static or per-item values. Supports Contains, Equals, Starts With, Ends With and Regex matching throughout.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "itemsArraySource",
    "displayName": "Items Array Source",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "useGa4Source",
        "displayValue": "GA4 event data (items)"
      },
      {
        "value": "useCustomSource",
        "displayValue": "Custom variable"
      }
    ],
    "simpleValueType": true,
    "help": "\"GA4 event data\" reads the incoming event's <code>items</code> array directly. Choose \"Custom variable\" to transform an array held in another variable.",
    "defaultValue": "useGa4Source",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "inputArrayVar",
    "displayName": "Items Array Variable",
    "simpleValueType": true,
    "help": "A variable that resolves to an array of objects. If it resolves to anything else, this variable returns <code>undefined</code>.",
    "valueHint": "{{Event Data - items}}",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "enablingConditions": [
      {
        "paramName": "itemsArraySource",
        "paramValue": "useCustomSource",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "itemFilteringGroup",
    "displayName": "1. Item Filtering — keep or drop whole items",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableItemFiltering",
        "checkboxText": "Enable item filtering",
        "simpleValueType": true,
        "help": "Removes entire items from the array. To remove a single parameter and keep the item, use section 2."
      },
      {
        "type": "SELECT",
        "name": "filterMode",
        "displayName": "What should the rules below do?",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "drop",
            "displayValue": "DROP items that match any rule (blocklist)"
          },
          {
            "value": "keep",
            "displayValue": "KEEP ONLY items that match any rule (allowlist)"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "drop",
        "help": "<b>DROP</b>: an item matching one or more rules is removed; everything else survives.<br><b>KEEP ONLY</b>: an item must match at least one rule to survive; everything else is removed. With KEEP ONLY and an empty rule table, the array comes back empty.",
        "enablingConditions": [
          {
            "paramName": "enableItemFiltering",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "filterCaseSensitive",
        "checkboxText": "Case-sensitive matching",
        "simpleValueType": true,
        "help": "Off by default, so <code>Medications</code> also matches <code>medications</code>.",
        "enablingConditions": [
          {
            "paramName": "enableItemFiltering",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "itemFilterRules",
        "displayName": "Filter Rules",
        "simpleTableColumns": [
          {
            "defaultValue": "item_name",
            "displayName": "Field to check",
            "name": "filterField",
            "type": "TEXT",
            "valueHint": "item_name",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "contains",
            "displayName": "Match type",
            "name": "filterMatchType",
            "type": "SELECT",
            "selectItems": [
              {
                "value": "contains",
                "displayValue": "Contains"
              },
              {
                "value": "equals",
                "displayValue": "Equals"
              },
              {
                "value": "startsWith",
                "displayValue": "Starts With"
              },
              {
                "value": "endsWith",
                "displayValue": "Ends With"
              },
              {
                "value": "regex",
                "displayValue": "Regex"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "filterKeyword",
            "type": "TEXT",
            "valueHint": "Medications",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "help": "A rule only matches if the field exists on the item. An item missing the field never matches — so under KEEP ONLY it is dropped.<br><b>Example:</b> <code>item_category</code> Contains <code>Medications</code>.",
        "newRowButtonText": "Add filter rule",
        "enablingConditions": [
          {
            "paramName": "enableItemFiltering",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Add or remove whole items from the array."
  },
  {
    "type": "GROUP",
    "name": "parameterActionGroup",
    "displayName": "2. Parameter Actions — add, drop or replace parameters",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableParameterActions",
        "checkboxText": "Enable parameter actions",
        "simpleValueType": true,
        "help": "Adds, removes or overwrites individual parameters. Every item stays in the array."
      },
      {
        "type": "CHECKBOX",
        "name": "parameterActionCaseSensitive",
        "checkboxText": "Case-sensitive matching (applies to every rule in this section)",
        "simpleValueType": true,
        "help": "Off by default.",
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "dropEmptyGroup",
        "displayName": "2a. Drop empty parameters",
        "groupStyle": "ZIPPY_CLOSED",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "dropEmptyParams",
            "checkboxText": "Drop parameters whose value is empty or whitespace",
            "simpleValueType": true,
            "help": "Removes parameters whose value is <code>\"\"</code> or only spaces, tabs or line breaks. A value of <code>0</code>, <code>false</code> or <code>null</code> is <i>not</i> empty and is kept."
          },
          {
            "type": "TEXT",
            "name": "dropEmptySpecificParams",
            "displayName": "Limit to these parameters (optional, comma-separated)",
            "simpleValueType": true,
            "valueHint": "item_variant, item_brand",
            "help": "Leave blank to check every parameter on every item.",
            "enablingConditions": [
              {
                "paramName": "dropEmptyParams",
                "paramValue": true,
                "type": "EQUALS"
              }
            ]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "dropAlwaysGroup",
        "displayName": "2b. Always drop these parameters",
        "groupStyle": "ZIPPY_CLOSED",
        "subParams": [
          {
            "type": "TEXT",
            "name": "dropAlwaysParams",
            "displayName": "Parameters to drop (comma-separated)",
            "simpleValueType": true,
            "valueHint": "item_id, item_brand",
            "help": "Removed from every item, no condition checked. Leave blank to skip."
          }
        ],
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "dropParamGroup",
        "displayName": "2c. Drop a parameter when a condition matches",
        "groupStyle": "ZIPPY_CLOSED",
        "subParams": [
          {
            "type": "SIMPLE_TABLE",
            "name": "parameterDropRules",
            "displayName": "Conditional drop rules",
            "simpleTableColumns": [
              {
                "defaultValue": "item_category",
                "displayName": "IF field",
                "name": "checkField",
                "type": "TEXT",
                "valueHint": "item_category",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "contains",
                "displayName": "Match",
                "name": "checkMatchType",
                "type": "SELECT",
                "selectItems": [
                  {
                    "value": "contains",
                    "displayValue": "Contains"
                  },
                  {
                    "value": "equals",
                    "displayValue": "Equals"
                  },
                  {
                    "value": "startsWith",
                    "displayValue": "Starts With"
                  },
                  {
                    "value": "endsWith",
                    "displayValue": "Ends With"
                  },
                  {
                    "value": "regex",
                    "displayValue": "Regex"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "Value",
                "name": "checkKeyword",
                "type": "TEXT",
                "valueHint": "Medications",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "item_name",
                "displayName": "THEN drop",
                "name": "targetParameter",
                "type": "TEXT",
                "valueHint": "item_name",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "help": "<b>Example:</b> IF <code>item_category</code> Contains <code>Medications</code> → drop <code>item_name</code>.<br>Leave \"IF field\" and \"THEN drop\" as the same key to drop a parameter based on its own value.",
            "newRowButtonText": "Add drop rule"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "replaceParamGroup",
        "displayName": "2d. Replace a parameter's value when a condition matches",
        "groupStyle": "ZIPPY_CLOSED",
        "subParams": [
          {
            "type": "SIMPLE_TABLE",
            "name": "parameterReplaceRules",
            "displayName": "Conditional replace rules",
            "simpleTableColumns": [
              {
                "defaultValue": "item_name",
                "displayName": "IF field",
                "name": "checkField",
                "type": "TEXT",
                "valueHint": "item_name",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "contains",
                "displayName": "Match",
                "name": "checkMatchType",
                "type": "SELECT",
                "selectItems": [
                  {
                    "value": "contains",
                    "displayValue": "Contains"
                  },
                  {
                    "value": "equals",
                    "displayValue": "Equals"
                  },
                  {
                    "value": "startsWith",
                    "displayValue": "Starts With"
                  },
                  {
                    "value": "endsWith",
                    "displayValue": "Ends With"
                  },
                  {
                    "value": "regex",
                    "displayValue": "Regex"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "Value",
                "name": "checkKeyword",
                "type": "TEXT",
                "valueHint": "Drug",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "item_link",
                "displayName": "THEN set",
                "name": "targetParameter",
                "type": "TEXT",
                "valueHint": "item_link",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "To value",
                "name": "replacementValue",
                "type": "TEXT",
                "valueHint": "https://example.com/",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "help": "<b>Example:</b> IF <code>item_name</code> Contains <code>Drug</code> → set <code>item_link</code> to <code>https://example.com/</code>.<br>By default this only overwrites a parameter the item already has. See the checkbox below to also create missing ones.",
            "newRowButtonText": "Add replace rule"
          },
          {
            "type": "CHECKBOX",
            "name": "replaceCreatesMissing",
            "checkboxText": "Also create the parameter if the item doesn't have it",
            "simpleValueType": true,
            "help": "Off by default, so a replace rule never invents parameters on items that lacked them. Turn this on if you want the rule to act as \"set or create\"."
          }
        ],
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "addParamGroup",
        "displayName": "2e. Add a new parameter when a condition matches",
        "groupStyle": "ZIPPY_CLOSED",
        "subParams": [
          {
            "type": "SIMPLE_TABLE",
            "name": "parameterAddRules",
            "displayName": "Conditional add rules",
            "simpleTableColumns": [
              {
                "defaultValue": "item_category",
                "displayName": "IF field",
                "name": "checkField",
                "type": "TEXT",
                "valueHint": "item_category",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "contains",
                "displayName": "Match",
                "name": "checkMatchType",
                "type": "SELECT",
                "selectItems": [
                  {
                    "value": "contains",
                    "displayValue": "Contains"
                  },
                  {
                    "value": "equals",
                    "displayValue": "Equals"
                  },
                  {
                    "value": "startsWith",
                    "displayValue": "Starts With"
                  },
                  {
                    "value": "endsWith",
                    "displayValue": "Ends With"
                  },
                  {
                    "value": "regex",
                    "displayValue": "Regex"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "Value",
                "name": "checkKeyword",
                "type": "TEXT",
                "valueHint": "Medications",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "THEN add key",
                "name": "newParameter",
                "type": "TEXT",
                "valueHint": "restricted",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "With value",
                "name": "newParameterValue",
                "type": "TEXT",
                "valueHint": "true",
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "help": "<b>Example:</b> IF <code>item_category</code> Contains <code>Medications</code> → add <code>restricted</code> = <code>true</code>.<br>If the item already has that key, its value is overwritten.",
            "newRowButtonText": "Add rule"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "LABEL",
        "name": "paramActionOrderLabel",
        "displayName": "Within this section the order is: 2a empty → 2b always-drop → 2c conditional drop → 2d replace → 2e add. All conditions are evaluated against the item as it was when the section started, so one rule cannot cascade into another.",
        "enablingConditions": [
          {
            "paramName": "enableParameterActions",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Add, remove or overwrite individual parameters while keeping every item."
  },
  {
    "type": "GROUP",
    "name": "valueTransformGroup",
    "displayName": "3. Value Transformation — find and replace inside values",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableValueTransform",
        "checkboxText": "Enable value transformation",
        "simpleValueType": true,
        "help": "Rewrites text inside parameter values. For whole-value replacement use section 2c."
      },
      {
        "type": "CHECKBOX",
        "name": "transformCaseSensitive",
        "checkboxText": "Case-sensitive find",
        "simpleValueType": true,
        "help": "Off by default.",
        "enablingConditions": [
          {
            "paramName": "enableValueTransform",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "transformFieldRegex",
        "checkboxText": "Treat \"Field\" as a regex so one rule can hit many parameters",
        "simpleValueType": true,
        "help": "With this on, <code>item_.*</code> in the Field column matches <code>item_name</code>, <code>item_category</code> and so on. The pattern must match the whole key name. Applies to every rule in the table.",
        "enablingConditions": [
          {
            "paramName": "enableValueTransform",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "transformNonStrings",
        "checkboxText": "Also transform numbers and booleans (result becomes a string)",
        "simpleValueType": true,
        "help": "Off by default, so only string values are touched. With this on, a price of <code>19.99</code> can be rewritten, but the value ends up as text — re-cast it in section 4 if you need a number.",
        "enablingConditions": [
          {
            "paramName": "enableValueTransform",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "valueTransformRules",
        "displayName": "Find-and-replace rules",
        "simpleTableColumns": [
          {
            "defaultValue": "item_name",
            "displayName": "Field",
            "name": "transformField",
            "type": "TEXT",
            "valueHint": "item_name",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Find",
            "name": "findValue",
            "type": "TEXT",
            "valueHint": "Medications",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Replace with",
            "name": "replaceValue",
            "type": "TEXT",
            "valueHint": "Health Products (blank = delete the text)"
          },
          {
            "defaultValue": false,
            "displayName": "Find is regex",
            "name": "useRegex",
            "type": "SELECT",
            "selectItems": [
              {
                "value": false,
                "displayValue": "No"
              },
              {
                "value": true,
                "displayValue": "Yes"
              }
            ]
          }
        ],
        "help": "Every occurrence is replaced, not just the first. Rules run top to bottom on the same value, so a later rule sees the earlier rule's output.<br>With <b>Find is regex</b> = Yes the pattern uses RE2 syntax. Capture-group references such as <code>$1</code> are <b>not</b> supported in the replacement — it is inserted literally.",
        "newRowButtonText": "Add transform rule",
        "enablingConditions": [
          {
            "paramName": "enableValueTransform",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Rewrite words or patterns inside parameter values."
  },
  {
    "type": "GROUP",
    "name": "dataFormattingGroup",
    "displayName": "4. Data Types — cast values to number, integer or string",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableNumberFormat",
        "checkboxText": "Cast keys to decimal numbers",
        "simpleValueType": true,
        "help": "Use the key names as they arrive in the items array — renaming happens later, in section 6. A value that cannot be cast to a number becomes NaN, so only list keys you expect to be numeric."
      },
      {
        "type": "TEXT",
        "name": "numberKeys",
        "displayName": "Number keys (comma-separated)",
        "simpleValueType": true,
        "valueHint": "price, discount",
        "help": "<code>\"19.99\"</code> becomes <code>19.99</code>.",
        "enablingConditions": [
          {
            "paramName": "enableNumberFormat",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableIntegerFormat",
        "checkboxText": "Cast keys to integers",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "integerKeys",
        "displayName": "Integer keys (comma-separated)",
        "simpleValueType": true,
        "valueHint": "quantity, index",
        "help": "<code>\"3.7\"</code> becomes <code>3</code> — the decimal part is discarded, not rounded.",
        "enablingConditions": [
          {
            "paramName": "enableIntegerFormat",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableStringFormat",
        "checkboxText": "Cast keys to strings",
        "simpleValueType": true
      },
      {
        "type": "TEXT",
        "name": "stringKeys",
        "displayName": "String keys (comma-separated)",
        "simpleValueType": true,
        "valueHint": "item_id, item_category",
        "help": "<code>12345</code> becomes <code>\"12345\"</code>. Useful when a destination requires IDs as text.",
        "enablingConditions": [
          {
            "paramName": "enableStringFormat",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ],
    "help": "Force specific parameters to a data type before the array leaves this variable."
  },
  {
    "type": "GROUP",
    "name": "advanceConfig",
    "displayName": "5. Added Values — static and per-item values",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableStaticValues",
        "checkboxText": "Add the same key-value pair to every item",
        "simpleValueType": true,
        "help": "Keys added here are not affected by sections 1-4, but section 6 can still rename them."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "staticKeysValue",
        "displayName": "Static values",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "staticAttrKey",
            "type": "TEXT",
            "valueHint": "affiliation",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "staticAttrValue",
            "type": "TEXT",
            "valueHint": "Online Store",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "help": "Overwrites the key if an item already has it. Values can be GTM variables.",
        "newRowButtonText": "Add static value",
        "enablingConditions": [
          {
            "paramName": "enableStaticValues",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "enableItemIndex",
        "checkboxText": "Add each item's position in the array",
        "simpleValueType": true,
        "help": "Useful for <code>index</code> in GA4 item lists, or any destination that wants an explicit ordering field."
      },
      {
        "type": "TEXT",
        "name": "itemIndexKey",
        "displayName": "Position key name",
        "simpleValueType": true,
        "defaultValue": "index",
        "valueHint": "index",
        "help": "The key written onto each item.",
        "enablingConditions": [
          {
            "paramName": "enableItemIndex",
            "paramValue": true,
            "type": "EQUALS"
          }
        ],
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      },
      {
        "type": "SELECT",
        "name": "itemIndexStart",
        "displayName": "First item is numbered",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "one",
            "displayValue": "1 (GA4 item_list convention)"
          },
          {
            "value": "zero",
            "displayValue": "0"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "one",
        "help": "Positions reflect the array <i>after</i> filtering, so dropped items do not leave gaps.",
        "enablingConditions": [
          {
            "paramName": "enableItemIndex",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Append values that are not derived from the incoming item."
  },
  {
    "type": "GROUP",
    "name": "keyMappingGroup",
    "displayName": "6. Key Mapping — rename parameters",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "enableKeyMapping",
        "checkboxText": "Enable key renaming",
        "simpleValueType": true,
        "help": "Renames keys. Runs last, so every section above refers to keys by their original incoming names.",
        "defaultValue": false
      },
      {
        "type": "CHECKBOX",
        "name": "keepUnmappedKeys",
        "checkboxText": "Keep keys that are not in the table",
        "simpleValueType": true,
        "help": "On by default. Turn it off to output <i>only</i> the mapped keys, which is a quick way to whitelist parameters.",
        "defaultValue": true,
        "enablingConditions": [
          {
            "paramName": "enableKeyMapping",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "attrArrayTransformation",
        "displayName": "Rename table",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Current key",
            "name": "exAttrKey",
            "type": "TEXT",
            "valueHint": "item_name",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "New key",
            "name": "newAttrKey",
            "type": "TEXT",
            "valueHint": "product_name",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "help": "<b>Example:</b> <code>item_name</code> → <code>product_name</code>. If two keys map onto the same new name, the last one processed wins.",
        "newRowButtonText": "Add rename",
        "enablingConditions": [
          {
            "paramName": "enableKeyMapping",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ],
    "help": "Rename item parameters, optionally dropping everything unnamed."
  }
]

___SANDBOXED_JS_FOR_SERVER___

const Object = require('Object');
const getType = require('getType');
const makeTableMap = require('makeTableMap');
const makeNumber = require('makeNumber');
const makeInteger = require('makeInteger');
const makeString = require('makeString');
const getEventData = require('getEventData');
const logToConsole = require('logToConsole');
const createRegex = require('createRegex');
const testRegex = require('testRegex');

const LOG_PREFIX = 'sGTM Items Transformation: ';

/**
 * True if the object has this own key.
 */
const hasKey = function(obj, key) {
  return Object.keys(obj).indexOf(key) !== -1;
};

/**
 * Trim spaces, tabs, newlines and carriage returns from both ends.
 */
const trim = function(str) {
  if (getType(str) !== 'string') return str;
  const isSpace = function(ch) {
    return ch === ' ' || ch === '\t' || ch === '\n' || ch === '\r';
  };
  let start = 0;
  let end = str.length;
  while (start < end && isSpace(str[start])) start++;
  while (end > start && isSpace(str[end - 1])) end--;
  return str.substring(start, end);
};

/**
 * Split on a single-character delimiter and trim each part. Empty parts dropped.
 */
const splitString = function(str, delimiter) {
  const result = [];
  if (getType(str) !== 'string') return result;

  let current = '';
  for (let i = 0; i < str.length; i++) {
    if (str[i] === delimiter) {
      if (trim(current) !== '') result.push(trim(current));
      current = '';
    } else {
      current = current + str[i];
    }
  }
  if (trim(current) !== '') result.push(trim(current));
  return result;
};

const inList = function(list, value) {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === value) return true;
  }
  return false;
};

/**
 * Compile a regex, logging once on failure. Returns null when invalid.
 */
const compileRegex = function(pattern, caseSensitive) {
  const regex = createRegex(pattern, caseSensitive ? '' : 'i');
  if (regex === null) {
    logToConsole(LOG_PREFIX + 'invalid regex pattern, rule skipped: ' + pattern);
  }
  return regex;
};

/**
 * Does `value` satisfy `keyword` under `matchType`?
 * Non-strings are stringified first so numeric fields can be matched too.
 */
const checkMatch = function(value, keyword, matchType, caseSensitive) {
  const stringValue = getType(value) === 'string' ? value : makeString(value);

  if (matchType === 'regex') {
    const regex = compileRegex(keyword, caseSensitive);
    if (regex === null) return false;
    return testRegex(regex, stringValue);
  }

  const compareValue = caseSensitive ? stringValue : stringValue.toLowerCase();
  const compareKeyword = caseSensitive ? keyword : keyword.toLowerCase();

  if (matchType === 'equals') return compareValue === compareKeyword;
  if (matchType === 'startsWith') return compareValue.indexOf(compareKeyword) === 0;
  if (matchType === 'endsWith') {
    const tailIndex = compareValue.length - compareKeyword.length;
    return tailIndex >= 0 && compareValue.indexOf(compareKeyword, tailIndex) === tailIndex;
  }
  // 'contains' is the default for legacy configs with a blank match type.
  return compareValue.indexOf(compareKeyword) !== -1;
};

/**
 * Replace every plain-text occurrence of `find` in `str`.
 */
const replaceAll = function(str, find, replace, caseSensitive) {
  if (find === '') return str;

  const searchStr = caseSensitive ? find : find.toLowerCase();
  let result = '';
  let rest = str;

  while (rest.length > 0) {
    const haystack = caseSensitive ? rest : rest.toLowerCase();
    const index = haystack.indexOf(searchStr);
    if (index === -1) break;
    result = result + rest.substring(0, index) + replace;
    rest = rest.substring(index + find.length);
  }

  return result + rest;
};

/**
 * Replace every regex match in `str`.
 *
 * The sandbox has no String.prototype.replace and no way to ask a regex where
 * it matched, so match boundaries are found by testing anchored substrings:
 * for each start offset, grow the end offset until '^pattern$' accepts the
 * slice. That is the leftmost-longest match at that offset.
 *
 * ponytail: O(n^2) per value against the pattern. Item values are short enough
 * that this is cheaper than it looks; revisit only if profiling says so.
 */
const replaceWithRegex = function(str, pattern, replace, caseSensitive) {
  const regex = compileRegex('^(?:' + pattern + ')$', caseSensitive);
  if (regex === null) return str;

  let result = '';
  let position = 0;

  while (position < str.length) {
    let matchEnd = -1;
    // Longest match wins, mirroring how a global replace consumes input.
    for (let end = str.length; end > position; end--) {
      if (testRegex(regex, str.substring(position, end))) {
        matchEnd = end;
        break;
      }
    }

    if (matchEnd === -1) {
      result = result + str[position];
      position++;
    } else {
      result = result + replace;
      position = matchEnd;
    }
  }

  // A pattern that also accepts the empty string would otherwise never append
  // a trailing replacement; matching the whole remainder above covers it.
  return result;
};

/**
 * Does this key name match the configured field pattern?
 */
const fieldMatches = function(fieldName, pattern, useRegex, caseSensitive) {
  if (!useRegex) {
    if (caseSensitive) return fieldName === pattern;
    return fieldName.toLowerCase() === pattern.toLowerCase();
  }

  const regex = compileRegex('^(?:' + pattern + ')$', caseSensitive);
  if (regex === null) return fieldName === pattern;
  return testRegex(regex, fieldName);
};

/**
 * Shallow copy, so the incoming event data is never mutated.
 */
const copyItem = function(item) {
  const copy = {};
  const keys = Object.keys(item);
  for (let k = 0; k < keys.length; k++) {
    copy[keys[k]] = item[keys[k]];
  }
  return copy;
};

// ============================================================
// MAIN
// ============================================================

const inputArray = data.itemsArraySource === 'useGa4Source' ?
  getEventData('items') :
  data.inputArrayVar;

if (getType(inputArray) !== 'array') {
  logToConsole(LOG_PREFIX + 'input is not an array, returning undefined.');
  return undefined;
}

let workingArray = [];
for (let i = 0; i < inputArray.length; i++) {
  if (getType(inputArray[i]) === 'object') {
    workingArray.push(copyItem(inputArray[i]));
  } else {
    logToConsole(LOG_PREFIX + 'skipping non-object entry at index ' + i + '.');
  }
}

// ------------------------------------------------------------
// STEP 1: Item filtering (keep or drop whole items)
// ------------------------------------------------------------
if (data.enableItemFiltering) {
  const filterRules = getType(data.itemFilterRules) === 'array' ? data.itemFilterRules : [];
  const filterCaseSensitive = data.filterCaseSensitive || false;
  const keepOnly = data.filterMode === 'keep';

  workingArray = workingArray.filter(function(item) {
    let matched = false;
    for (let r = 0; r < filterRules.length; r++) {
      const rule = filterRules[r];
      if (hasKey(item, rule.filterField) &&
          checkMatch(item[rule.filterField], rule.filterKeyword, rule.filterMatchType, filterCaseSensitive)) {
        matched = true;
        break;
      }
    }
    // KEEP ONLY: survive by matching. DROP: survive by not matching.
    return keepOnly ? matched : !matched;
  });
}

// ------------------------------------------------------------
// STEP 2: Parameter actions (empty, drop, replace, add)
// ------------------------------------------------------------
if (data.enableParameterActions) {
  const caseSensitive = data.parameterActionCaseSensitive || false;
  const dropRules = getType(data.parameterDropRules) === 'array' ? data.parameterDropRules : [];
  const replaceRules = getType(data.parameterReplaceRules) === 'array' ? data.parameterReplaceRules : [];
  const addRules = getType(data.parameterAddRules) === 'array' ? data.parameterAddRules : [];
  const dropEmptyEnabled = data.dropEmptyParams || false;
  const dropEmptyOnly = data.dropEmptySpecificParams ?
    splitString(data.dropEmptySpecificParams, ',') : [];
  const dropAlways = data.dropAlwaysParams ?
    splitString(data.dropAlwaysParams, ',') : [];
  const replaceCreatesMissing = data.replaceCreatesMissing || false;

  const isEmptyValue = function(value) {
    if (getType(value) !== 'string') return false;
    return trim(value) === '';
  };

  if (dropEmptyEnabled || dropAlways.length > 0 || dropRules.length > 0 ||
      replaceRules.length > 0 || addRules.length > 0) {
    workingArray = workingArray.map(function(item) {
      // Conditions read `item`, which is never written during rule evaluation,
      // so rules cannot cascade into each other.
      const paramsToDrop = [];
      const paramsToSet = {};

      // 2a. empty values
      if (dropEmptyEnabled) {
        const itemKeys = Object.keys(item);
        for (let k = 0; k < itemKeys.length; k++) {
          const key = itemKeys[k];
          const inScope = dropEmptyOnly.length === 0 || inList(dropEmptyOnly, key);
          if (inScope && isEmptyValue(item[key])) {
            paramsToDrop.push(key);
          }
        }
      }

      // 2b. unconditional drop
      for (let n = 0; n < dropAlways.length; n++) {
        if (hasKey(item, dropAlways[n])) paramsToDrop.push(dropAlways[n]);
      }

      // 2c. conditional drop
      for (let d = 0; d < dropRules.length; d++) {
        const dropRule = dropRules[d];
        if (hasKey(item, dropRule.checkField) &&
            hasKey(item, dropRule.targetParameter) &&
            checkMatch(item[dropRule.checkField], dropRule.checkKeyword, dropRule.checkMatchType, caseSensitive)) {
          paramsToDrop.push(dropRule.targetParameter);
        }
      }

      // 2d. conditional replace
      for (let p = 0; p < replaceRules.length; p++) {
        const replaceRule = replaceRules[p];
        const targetExists = hasKey(item, replaceRule.targetParameter);
        if (!targetExists && !replaceCreatesMissing) continue;
        if (hasKey(item, replaceRule.checkField) &&
            checkMatch(item[replaceRule.checkField], replaceRule.checkKeyword, replaceRule.checkMatchType, caseSensitive)) {
          paramsToSet[replaceRule.targetParameter] = replaceRule.replacementValue;
        }
      }

      // 2e. conditional add
      for (let a = 0; a < addRules.length; a++) {
        const addRule = addRules[a];
        if (hasKey(item, addRule.checkField) &&
            checkMatch(item[addRule.checkField], addRule.checkKeyword, addRule.checkMatchType, caseSensitive)) {
          paramsToSet[addRule.newParameter] = addRule.newParameterValue;
        }
      }

      const setKeys = Object.keys(paramsToSet);
      if (paramsToDrop.length === 0 && setKeys.length === 0) return item;

      const newItem = {};
      const itemKeys = Object.keys(item);
      for (let k = 0; k < itemKeys.length; k++) {
        const key = itemKeys[k];
        if (!inList(paramsToDrop, key)) newItem[key] = item[key];
      }
      // A set wins over a drop for the same key, so an explicit new value is
      // never silently discarded.
      for (let s = 0; s < setKeys.length; s++) {
        newItem[setKeys[s]] = paramsToSet[setKeys[s]];
      }
      return newItem;
    });
  }
}

// ------------------------------------------------------------
// STEP 3: Value transformation (find and replace within values)
// ------------------------------------------------------------
if (data.enableValueTransform && getType(data.valueTransformRules) === 'array' && data.valueTransformRules.length > 0) {
  const transformRules = data.valueTransformRules;
  const caseSensitive = data.transformCaseSensitive || false;
  const useFieldRegex = data.transformFieldRegex || false;
  const includeNonStrings = data.transformNonStrings || false;

  workingArray = workingArray.map(function(item) {
    const itemKeys = Object.keys(item);

    for (let r = 0; r < transformRules.length; r++) {
      const rule = transformRules[r];
      const replaceValue = rule.replaceValue || '';
      const useRegexForFind = rule.useRegex === true || rule.useRegex === 'true';

      for (let k = 0; k < itemKeys.length; k++) {
        const fieldName = itemKeys[k];
        if (!fieldMatches(fieldName, rule.transformField, useFieldRegex, caseSensitive)) continue;

        const currentValue = item[fieldName];
        const valueType = getType(currentValue);
        let stringValue;

        if (valueType === 'string') {
          stringValue = currentValue;
        } else if (includeNonStrings && (valueType === 'number' || valueType === 'boolean')) {
          stringValue = makeString(currentValue);
        } else {
          continue;
        }

        item[fieldName] = useRegexForFind ?
          replaceWithRegex(stringValue, rule.findValue, replaceValue, caseSensitive) :
          replaceAll(stringValue, rule.findValue, replaceValue, caseSensitive);
      }
    }
    return item;
  });
}

// ------------------------------------------------------------
// STEP 4: Data type casting
// ------------------------------------------------------------
const numberKeys = data.enableNumberFormat && data.numberKeys ? splitString(data.numberKeys, ',') : [];
const integerKeys = data.enableIntegerFormat && data.integerKeys ? splitString(data.integerKeys, ',') : [];
const stringKeys = data.enableStringFormat && data.stringKeys ? splitString(data.stringKeys, ',') : [];

if (numberKeys.length > 0 || integerKeys.length > 0 || stringKeys.length > 0) {
  workingArray = workingArray.map(function(item) {
    const itemKeys = Object.keys(item);

    for (let k = 0; k < itemKeys.length; k++) {
      const key = itemKeys[k];
      if (inList(numberKeys, key)) {
        item[key] = makeNumber(item[key]);
      } else if (inList(integerKeys, key)) {
        item[key] = makeInteger(item[key]);
      } else if (inList(stringKeys, key)) {
        item[key] = makeString(item[key]);
      }
    }
    return item;
  });
}

// ------------------------------------------------------------
// STEP 5: Added values (static pairs, then item position)
// ------------------------------------------------------------
if (data.enableStaticValues && getType(data.staticKeysValue) === 'array' && data.staticKeysValue.length > 0) {
  const staticKeyMapping = makeTableMap(data.staticKeysValue, 'staticAttrKey', 'staticAttrValue');

  if (staticKeyMapping) {
    const staticKeys = Object.keys(staticKeyMapping);
    workingArray = workingArray.map(function(item) {
      for (let s = 0; s < staticKeys.length; s++) {
        item[staticKeys[s]] = staticKeyMapping[staticKeys[s]];
      }
      return item;
    });
  }
}

if (data.enableItemIndex && data.itemIndexKey) {
  const indexKey = data.itemIndexKey;
  const offset = data.itemIndexStart === 'zero' ? 0 : 1;
  for (let i = 0; i < workingArray.length; i++) {
    workingArray[i][indexKey] = i + offset;
  }
}

// ------------------------------------------------------------
// STEP 6: Key mapping (rename keys)
//
// Runs last so every section above takes the original key names. That also
// means keys added in step 5 can be renamed here like any other.
// ------------------------------------------------------------
if (data.enableKeyMapping && getType(data.attrArrayTransformation) === 'array' && data.attrArrayTransformation.length > 0) {
  const keyMapping = makeTableMap(data.attrArrayTransformation, 'exAttrKey', 'newAttrKey');
  const keepUnmappedKeys = data.keepUnmappedKeys !== false;

  if (keyMapping) {
    workingArray = workingArray.map(function(item) {
      const renamedItem = {};
      const itemKeys = Object.keys(item);

      for (let k = 0; k < itemKeys.length; k++) {
        const originalKey = itemKeys[k];
        if (hasKey(keyMapping, originalKey)) {
          renamedItem[keyMapping[originalKey]] = item[originalKey];
        } else if (keepUnmappedKeys) {
          renamedItem[originalKey] = item[originalKey];
        }
      }
      return renamedItem;
    });
  }
}

return workingArray;


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Returns undefined when the input is not an array
  code: |-
    mock('getEventData', 'not an array');

    const variableResult = runCode({itemsArraySource: 'useGa4Source'});

    assertThat(variableResult).isUndefined();
- name: Passes the array through untouched when nothing is enabled
  code: |-
    const items = [{item_id: 'A', item_name: 'Aspirin', price: 9.99}];
    mock('getEventData', items);

    const variableResult = runCode({itemsArraySource: 'useGa4Source'});

    assertThat(variableResult).isEqualTo(items);
- name: Reads from a custom variable instead of event data
  code: |-
    const variableResult = runCode({
      itemsArraySource: 'useCustomSource',
      inputArrayVar: [{item_id: 'A'}]
    });

    assertThat(variableResult).isEqualTo([{item_id: 'A'}]);
- name: Does not mutate the incoming event data
  code: |-
    const items = [{item_name: 'Aspirin'}];
    mock('getEventData', items);

    runCode({
      itemsArraySource: 'useGa4Source',
      enableKeyMapping: true,
      attrArrayTransformation: [{exAttrKey: 'item_name', newAttrKey: 'product_name'}]
    });

    assertThat(items[0].item_name).isEqualTo('Aspirin');
- name: Skips non-object entries in the array
  code: |-
    mock('getEventData', [{item_id: 'A'}, 'junk', 42, {item_id: 'B'}]);

    const variableResult = runCode({itemsArraySource: 'useGa4Source'});

    assertThat(variableResult).isEqualTo([{item_id: 'A'}, {item_id: 'B'}]);
- name: Step 1 - drop mode removes matching items
  code: |-
    mock('getEventData', [
      {item_name: 'Aspirin', item_category: 'Medications'},
      {item_name: 'Shampoo', item_category: 'Beauty'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemFiltering: true,
      filterMode: 'drop',
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'contains', filterKeyword: 'medications'}]
    });

    assertThat(variableResult.length).isEqualTo(1);
    assertThat(variableResult[0].item_name).isEqualTo('Shampoo');
- name: Step 1 - keep-only mode is an allowlist
  code: |-
    mock('getEventData', [
      {item_name: 'Aspirin', item_category: 'Medications'},
      {item_name: 'Shampoo', item_category: 'Beauty'},
      {item_name: 'Mystery'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemFiltering: true,
      filterMode: 'keep',
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'equals', filterKeyword: 'Beauty'}]
    });

    assertThat(variableResult.length).isEqualTo(1);
    assertThat(variableResult[0].item_name).isEqualTo('Shampoo');
- name: Step 1 - case-sensitive matching respects the checkbox
  code: |-
    const items = [{item_category: 'Medications'}];

    const insensitive = runCode({
      itemsArraySource: 'useCustomSource', inputArrayVar: items,
      enableItemFiltering: true, filterMode: 'drop', filterCaseSensitive: false,
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'equals', filterKeyword: 'medications'}]
    });
    assertThat(insensitive.length).isEqualTo(0);

    const sensitive = runCode({
      itemsArraySource: 'useCustomSource', inputArrayVar: items,
      enableItemFiltering: true, filterMode: 'drop', filterCaseSensitive: true,
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'equals', filterKeyword: 'medications'}]
    });
    assertThat(sensitive.length).isEqualTo(1);
- name: Step 1 - all match types behave as documented
  code: |-
    const run = function(matchType, keyword) {
      return runCode({
        itemsArraySource: 'useCustomSource',
        inputArrayVar: [{f: 'Pain Relief Tablets'}],
        enableItemFiltering: true, filterMode: 'keep',
        itemFilterRules: [{filterField: 'f', filterMatchType: matchType, filterKeyword: keyword}]
      }).length;
    };

    assertThat(run('contains', 'Relief')).isEqualTo(1);
    assertThat(run('contains', 'Vitamin')).isEqualTo(0);
    assertThat(run('equals', 'Pain Relief Tablets')).isEqualTo(1);
    assertThat(run('equals', 'Pain')).isEqualTo(0);
    assertThat(run('startsWith', 'Pain')).isEqualTo(1);
    assertThat(run('startsWith', 'Tablets')).isEqualTo(0);
    assertThat(run('endsWith', 'Tablets')).isEqualTo(1);
    assertThat(run('endsWith', 'Pain')).isEqualTo(0);
    assertThat(run('regex', '^Pain.*Tablets$')).isEqualTo(1);
    assertThat(run('regex', '^Vitamin')).isEqualTo(0);
- name: Step 1 - endsWith matches a repeated suffix
  code: |-
    const variableResult = runCode({
      itemsArraySource: 'useCustomSource',
      inputArrayVar: [{f: 'ab-ab'}],
      enableItemFiltering: true, filterMode: 'keep',
      itemFilterRules: [{filterField: 'f', filterMatchType: 'endsWith', filterKeyword: 'ab'}]
    });

    assertThat(variableResult.length).isEqualTo(1);
- name: Step 1 - an item missing the field never matches
  code: |-
    mock('getEventData', [{item_name: 'Aspirin'}]);

    const dropped = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemFiltering: true, filterMode: 'drop',
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'contains', filterKeyword: 'x'}]
    });
    assertThat(dropped.length).isEqualTo(1);

    const kept = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemFiltering: true, filterMode: 'keep',
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'contains', filterKeyword: 'x'}]
    });
    assertThat(kept.length).isEqualTo(0);
- name: Step 2a - drops empty and whitespace-only values but keeps 0 and false
  code: |-
    mock('getEventData', [{
      item_name: 'Aspirin', item_brand: '', item_variant: '   ',
      item_note: '\t\n', price: 0, on_sale: false
    }]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      dropEmptyParams: true
    });

    assertThat(variableResult[0]).isEqualTo({item_name: 'Aspirin', price: 0, on_sale: false});
- name: Step 2a - only checks the listed parameters when a list is given
  code: |-
    mock('getEventData', [{item_brand: '', item_variant: ''}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      dropEmptyParams: true,
      dropEmptySpecificParams: ' item_brand , '
    });

    assertThat(variableResult[0]).isEqualTo({item_variant: ''});
- name: Step 2b - always drops the listed parameters from every item
  code: |-
    mock('getEventData', [
      {item_id: 'SKU1', item_name: 'Aspirin', item_brand: 'Bayer'},
      {item_id: 'SKU2', item_name: 'Shampoo'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      dropAlwaysParams: ' item_id , item_brand '
    });

    assertThat(variableResult[0]).isEqualTo({item_name: 'Aspirin'});
    assertThat(variableResult[1]).isEqualTo({item_name: 'Shampoo'});
- name: Step 2b - a blank list leaves every item untouched
  code: |-
    mock('getEventData', [{item_id: 'SKU1', item_name: 'Aspirin'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      dropAlwaysParams: ''
    });

    assertThat(variableResult[0]).isEqualTo({item_id: 'SKU1', item_name: 'Aspirin'});
- name: Step 2c - drops the target parameter and keeps the item
  code: |-
    mock('getEventData', [
      {item_name: 'Aspirin', item_category: 'Medications'},
      {item_name: 'Shampoo', item_category: 'Beauty'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterDropRules: [{
        checkField: 'item_category', checkMatchType: 'contains',
        checkKeyword: 'Medications', targetParameter: 'item_name'
      }]
    });

    assertThat(variableResult.length).isEqualTo(2);
    assertThat(variableResult[0]).isEqualTo({item_category: 'Medications'});
    assertThat(variableResult[1].item_name).isEqualTo('Shampoo');
- name: Step 2d - replace does not create a missing parameter by default
  code: |-
    mock('getEventData', [{item_name: 'Drug X'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterReplaceRules: [{
        checkField: 'item_name', checkMatchType: 'contains', checkKeyword: 'Drug',
        targetParameter: 'item_link', replacementValue: 'https://example.com/'
      }]
    });

    assertThat(variableResult[0]).isEqualTo({item_name: 'Drug X'});
- name: Step 2d - replace creates a missing parameter when opted in
  code: |-
    mock('getEventData', [{item_name: 'Drug X'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      replaceCreatesMissing: true,
      parameterReplaceRules: [{
        checkField: 'item_name', checkMatchType: 'contains', checkKeyword: 'Drug',
        targetParameter: 'item_link', replacementValue: 'https://example.com/'
      }]
    });

    assertThat(variableResult[0].item_link).isEqualTo('https://example.com/');
- name: Step 2d - replace overwrites an existing parameter
  code: |-
    mock('getEventData', [{item_name: 'Drug X', item_link: 'https://old.example/drug'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterReplaceRules: [{
        checkField: 'item_name', checkMatchType: 'contains', checkKeyword: 'Drug',
        targetParameter: 'item_link', replacementValue: 'https://example.com/'
      }]
    });

    assertThat(variableResult[0].item_link).isEqualTo('https://example.com/');
- name: Step 2e - adds a new parameter on a match only
  code: |-
    mock('getEventData', [
      {item_category: 'Medications'},
      {item_category: 'Beauty'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterAddRules: [{
        checkField: 'item_category', checkMatchType: 'equals', checkKeyword: 'Medications',
        newParameter: 'restricted', newParameterValue: 'true'
      }]
    });

    assertThat(variableResult[0].restricted).isEqualTo('true');
    assertThat(variableResult[1]).isEqualTo({item_category: 'Beauty'});
- name: Step 2 - regex match type works in parameter rules
  code: |-
    mock('getEventData', [{sku: 'RX-00912', item_name: 'Aspirin'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterDropRules: [{
        checkField: 'sku', checkMatchType: 'regex',
        checkKeyword: '^RX-\\d+$', targetParameter: 'item_name'
      }]
    });

    assertThat(variableResult[0]).isEqualTo({sku: 'RX-00912'});
- name: Step 2 - an invalid regex skips the rule instead of failing
  code: |-
    mock('getEventData', [{sku: 'RX-1', item_name: 'Aspirin'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterDropRules: [{
        checkField: 'sku', checkMatchType: 'regex',
        checkKeyword: '([unclosed', targetParameter: 'item_name'
      }]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Aspirin');
- name: Step 2 - rules do not cascade into one another
  code: |-
    mock('getEventData', [{item_name: 'Aspirin', item_category: 'Medications'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      parameterReplaceRules: [{
        checkField: 'item_category', checkMatchType: 'equals', checkKeyword: 'Medications',
        targetParameter: 'item_category', replacementValue: 'Health'
      }],
      parameterAddRules: [{
        checkField: 'item_category', checkMatchType: 'equals', checkKeyword: 'Health',
        newParameter: 'should_not_exist', newParameterValue: 'yes'
      }]
    });

    assertThat(variableResult[0].item_category).isEqualTo('Health');
    assertThat(variableResult[0].should_not_exist).isUndefined();
- name: Step 2 - an explicit new value survives a drop of the same key
  code: |-
    mock('getEventData', [{item_brand: '', item_name: 'Aspirin'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableParameterActions: true,
      dropEmptyParams: true,
      parameterAddRules: [{
        checkField: 'item_name', checkMatchType: 'contains', checkKeyword: 'Aspirin',
        newParameter: 'item_brand', newParameterValue: 'Generic'
      }]
    });

    assertThat(variableResult[0].item_brand).isEqualTo('Generic');
- name: Step 3 - plain find-and-replace hits every occurrence
  code: |-
    mock('getEventData', [{item_name: 'Medications and more Medications'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [{transformField: 'item_name', findValue: 'Medications', replaceValue: 'Health Products'}]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Health Products and more Health Products');
- name: Step 3 - a blank replacement deletes the text
  code: |-
    mock('getEventData', [{item_name: 'Aspirin (RX)'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [{transformField: 'item_name', findValue: ' (RX)', replaceValue: ''}]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Aspirin');
- name: Step 3 - replacement containing the search text does not loop forever
  code: |-
    mock('getEventData', [{item_name: 'cat'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [{transformField: 'item_name', findValue: 'cat', replaceValue: 'cat-cat'}]
    });

    assertThat(variableResult[0].item_name).isEqualTo('cat-cat');
- name: Step 3 - case-insensitive find preserves the replacement casing
  code: |-
    mock('getEventData', [{item_name: 'MEDICATIONS for medications'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      transformCaseSensitive: false,
      valueTransformRules: [{transformField: 'item_name', findValue: 'medications', replaceValue: 'Health'}]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Health for Health');
- name: Step 3 - regex replacement replaces every match
  code: |-
    mock('getEventData', [{item_name: 'Drug123 and Drug456'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [{
        transformField: 'item_name', findValue: 'Drug\\d+',
        replaceValue: 'Product', useRegex: true
      }]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Product and Product');
- name: Step 3 - regex replacement keeps surrounding text intact
  code: |-
    mock('getEventData', [{sku: 'prefix-RX-00912-suffix'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [{
        transformField: 'sku', findValue: 'RX-\\d+',
        replaceValue: 'MASKED', useRegex: true
      }]
    });

    assertThat(variableResult[0].sku).isEqualTo('prefix-MASKED-suffix');
- name: Step 3 - an invalid regex leaves the value unchanged
  code: |-
    mock('getEventData', [{item_name: 'Aspirin'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [{
        transformField: 'item_name', findValue: '([unclosed',
        replaceValue: 'X', useRegex: true
      }]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Aspirin');
- name: Step 3 - field regex applies one rule to many parameters
  code: |-
    mock('getEventData', [{item_name: 'RX Aspirin', item_category: 'RX Drugs', other: 'RX Keep'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      transformFieldRegex: true,
      valueTransformRules: [{transformField: 'item_.*', findValue: 'RX ', replaceValue: ''}]
    });

    assertThat(variableResult[0].item_name).isEqualTo('Aspirin');
    assertThat(variableResult[0].item_category).isEqualTo('Drugs');
    assertThat(variableResult[0].other).isEqualTo('RX Keep');
- name: Step 3 - non-strings are skipped unless opted in
  code: |-
    const items = [{price: 19.99}];

    const skipped = runCode({
      itemsArraySource: 'useCustomSource', inputArrayVar: items,
      enableValueTransform: true,
      valueTransformRules: [{transformField: 'price', findValue: '19', replaceValue: '29'}]
    });
    assertThat(skipped[0].price).isEqualTo(19.99);

    const included = runCode({
      itemsArraySource: 'useCustomSource', inputArrayVar: items,
      enableValueTransform: true, transformNonStrings: true,
      valueTransformRules: [{transformField: 'price', findValue: '19', replaceValue: '29'}]
    });
    assertThat(included[0].price).isEqualTo('29.99');
- name: Step 3 - rules run in order on the same value
  code: |-
    mock('getEventData', [{item_name: 'A'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableValueTransform: true,
      valueTransformRules: [
        {transformField: 'item_name', findValue: 'A', replaceValue: 'B'},
        {transformField: 'item_name', findValue: 'B', replaceValue: 'C'}
      ]
    });

    assertThat(variableResult[0].item_name).isEqualTo('C');
- name: Step 6 - renames mapped keys and keeps the rest by default
  code: |-
    mock('getEventData', [{item_name: 'Aspirin', item_id: 'A1'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableKeyMapping: true,
      attrArrayTransformation: [{exAttrKey: 'item_name', newAttrKey: 'product_name'}]
    });

    assertThat(variableResult[0]).isEqualTo({product_name: 'Aspirin', item_id: 'A1'});
- name: Step 6 - dropping unmapped keys whitelists the output
  code: |-
    mock('getEventData', [{item_name: 'Aspirin', item_id: 'A1', secret: 'x'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableKeyMapping: true,
      keepUnmappedKeys: false,
      attrArrayTransformation: [{exAttrKey: 'item_name', newAttrKey: 'product_name'}]
    });

    assertThat(variableResult[0]).isEqualTo({product_name: 'Aspirin'});
- name: Step 4 - casts to number, integer and string
  code: |-
    mock('getEventData', [{price: '19.99', quantity: '3.7', item_id: 12345}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableNumberFormat: true, numberKeys: 'price',
      enableIntegerFormat: true, integerKeys: ' quantity ',
      enableStringFormat: true, stringKeys: 'item_id'
    });

    assertThat(variableResult[0].price).isEqualTo(19.99);
    assertThat(variableResult[0].quantity).isEqualTo(3);
    assertThat(variableResult[0].item_id).isEqualTo('12345');
- name: Step 4 - casting uses the original key name, not the renamed one
  code: |-
    mock('getEventData', [{price: '19.99'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableKeyMapping: true,
      attrArrayTransformation: [{exAttrKey: 'price', newAttrKey: 'unit_price'}],
      enableNumberFormat: true, numberKeys: 'price'
    });

    assertThat(variableResult[0].unit_price).isEqualTo(19.99);
- name: Step 6 - renaming applies to a key added in step 5
  code: |-
    mock('getEventData', [{item_id: 'A'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableStaticValues: true,
      staticKeysValue: [{staticAttrKey: 'affiliation', staticAttrValue: 'Online Store'}],
      enableKeyMapping: true,
      attrArrayTransformation: [{exAttrKey: 'affiliation', newAttrKey: 'store'}]
    });

    assertThat(variableResult[0]).isEqualTo({item_id: 'A', store: 'Online Store'});
- name: Step 5 - adds static values to every item
  code: |-
    mock('getEventData', [{item_id: 'A'}, {item_id: 'B'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableStaticValues: true,
      staticKeysValue: [{staticAttrKey: 'affiliation', staticAttrValue: 'Online Store'}]
    });

    assertThat(variableResult[0].affiliation).isEqualTo('Online Store');
    assertThat(variableResult[1].affiliation).isEqualTo('Online Store');
- name: Step 5 - static values are skipped when the checkbox is off
  code: |-
    mock('getEventData', [{item_id: 'A'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableStaticValues: false,
      staticKeysValue: [{staticAttrKey: 'affiliation', staticAttrValue: 'Online Store'}]
    });

    assertThat(variableResult[0]).isEqualTo({item_id: 'A'});
- name: Step 5 - item position is 1-based by default and has no gaps after filtering
  code: |-
    mock('getEventData', [
      {item_id: 'A', item_category: 'Beauty'},
      {item_id: 'B', item_category: 'Medications'},
      {item_id: 'C', item_category: 'Beauty'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemFiltering: true, filterMode: 'drop',
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'equals', filterKeyword: 'Medications'}],
      enableItemIndex: true, itemIndexKey: 'index', itemIndexStart: 'one'
    });

    assertThat(variableResult.length).isEqualTo(2);
    assertThat(variableResult[0].index).isEqualTo(1);
    assertThat(variableResult[1].index).isEqualTo(2);
- name: Step 5 - item position can start at zero
  code: |-
    mock('getEventData', [{item_id: 'A'}, {item_id: 'B'}]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemIndex: true, itemIndexKey: 'position', itemIndexStart: 'zero'
    });

    assertThat(variableResult[0].position).isEqualTo(0);
    assertThat(variableResult[1].position).isEqualTo(1);
- name: All six sections run together in the documented order
  code: |-
    mock('getEventData', [
      {item_id: 'A1', item_name: 'RX Aspirin', item_category: 'Medications', price: '9.99', item_brand: ''},
      {item_id: 'B2', item_name: 'RX Shampoo', item_category: 'Beauty', price: '4.50', item_brand: 'Acme'},
      {item_id: 'C3', item_name: 'Banned Item', item_category: 'Weapons', price: '1.00'}
    ]);

    const variableResult = runCode({
      itemsArraySource: 'useGa4Source',
      enableItemFiltering: true,
      filterMode: 'drop',
      itemFilterRules: [{filterField: 'item_category', filterMatchType: 'equals', filterKeyword: 'Weapons'}],
      enableParameterActions: true,
      dropEmptyParams: true,
      parameterAddRules: [{
        checkField: 'item_category', checkMatchType: 'equals', checkKeyword: 'Medications',
        newParameter: 'restricted', newParameterValue: 'true'
      }],
      enableValueTransform: true,
      valueTransformRules: [{transformField: 'item_name', findValue: 'RX ', replaceValue: ''}],
      enableKeyMapping: true,
      attrArrayTransformation: [{exAttrKey: 'item_name', newAttrKey: 'product_name'}],
      enableNumberFormat: true,
      numberKeys: 'price',
      enableStaticValues: true,
      staticKeysValue: [{staticAttrKey: 'affiliation', staticAttrValue: 'Online Store'}],
      enableItemIndex: true,
      itemIndexKey: 'index',
      itemIndexStart: 'one'
    });

    assertThat(variableResult.length).isEqualTo(2);
    assertThat(variableResult[0]).isEqualTo({
      item_id: 'A1', product_name: 'Aspirin', item_category: 'Medications',
      price: 9.99, restricted: 'true', affiliation: 'Online Store', index: 1
    });
    assertThat(variableResult[1]).isEqualTo({
      item_id: 'B2', product_name: 'Shampoo', item_category: 'Beauty',
      price: 4.5, item_brand: 'Acme', affiliation: 'Online Store', index: 2
    });
setup: |-
  const assertThat = require('assertThat');
  const mock = require('mock');


___NOTES___

sGTM Items Array Transformation
==============================

A server-side GTM variable that returns a transformed copy of an items array.
The input is never mutated.

ORDER OF OPERATIONS
-------------------
Sections always run in this order, each one working on the previous one's
output:

  1. Item Filtering        keep or drop whole items
  2. Parameter Actions     empty -> drop -> replace -> add
  3. Value Transformation  find-and-replace inside values
  4. Data Types            cast to number / integer / string
  5. Added Values          static pairs, then item position
  6. Key Mapping           rename keys

Renaming runs last on purpose: every other section refers to keys by the names
they arrive with, so you configure the whole variable against the incoming GA4
field names and never have to track what a key was renamed to.

Two consequences worth remembering:
  - Section 4 takes the ORIGINAL key name, even if section 6 renames it.
  - A key added in section 5 can still be renamed by section 6.

WHICH SECTION DO I WANT?
------------------------
  Remove a whole item ......................... 1 (DROP mode)
  Keep only certain items ..................... 1 (KEEP ONLY mode)
  Remove parameters that came through blank ... 2a
  Remove one parameter, keep the item ......... 2b
  Overwrite a whole value ..................... 2c
  Flag items with a new parameter ............. 2d
  Rewrite words inside a value ................ 3
  Fix "price is a string" ..................... 4
  Add affiliation / list name to all items .... 5
  Add index / position per item ............... 5
  Rename a parameter .......................... 6
  Output only an approved set of parameters ... 6 (uncheck "keep unmapped")

MATCHING
--------
Contains, Equals, Starts With, Ends With and Regex are available in step 1 and
every step 2 rule. Matching is case-insensitive unless the section's
case-sensitive checkbox is ticked. Numeric values are stringified before
matching, so `price` Equals `9.99` works.

A rule whose "IF field" does not exist on an item never matches. Under KEEP
ONLY that means the item is dropped.

REGEX
-----
Patterns use Google's RE2 syntax, not JavaScript's: no backreferences and no
lookahead or lookbehind. Common pieces work as expected: `.*`, `^`, `$`,
`[a-z]`, `\d`, `\w`, `+`, `?`, `{2,4}`, `(a|b)`.

Match-type regex (steps 1 and 2) is an unanchored search, so `RX-\d+` matches
anywhere in the value. Anchor it with `^...$` for a whole-value match.

Replacement regex (step 3) replaces every match, leaving surrounding text
intact. Capture-group references such as `$1` are NOT supported — the
replacement is inserted literally. An invalid pattern is logged in the preview
console and the rule is skipped; the value is left unchanged.

EMPTY VALUES
------------
Step 2a treats `""` and whitespace-only strings (spaces, tabs, newlines) as
empty. It does not treat `0`, `false` or `null` as empty — those are kept.

DEBUGGING
---------
Skipped non-object entries, invalid regex patterns and a non-array input are
logged to the preview console.

If the variable returns `undefined`, the source did not resolve to an array.
Check the event has an `items` array, or that the custom variable resolves to
one.

CHANGELOG
---------
Created 2025-02-15.
2025-11-25  Converted to server-side; item filtering and value transformation.
2025-11-25  Regex support for value transformation.
2025-11-25  Parameter Actions (conditional drop / replace).
2026-10-05  Fixed regex replacement, which previously relied on
            String.prototype.replace and failed at runtime in the sandbox.
            Fixed whitespace trimming to cover tabs and newlines.
            Added: KEEP ONLY filter mode, conditional parameter add, per-item
            position, opt-in create-on-replace, opt-in non-string transforms,
            regex match type for item filtering.
            Reorganised the UI into numbered sections with nested groups, and
            documented the order of operations in the editor.
            Moved Key Mapping to run last, so every other section refers to
            keys by their original incoming names.
            Added test coverage for every section.
