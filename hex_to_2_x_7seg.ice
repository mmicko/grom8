{
  "version": "1.1",
  "package": {
    "name": "HEX to 2 x 7seg",
    "version": "1.0",
    "description": "8-bit value to two 7seg displays",
    "author": "Miodrag Milanovic",
    "image": "%3Csvg%20xmlns=%22http://www.w3.org/2000/svg%22%20width=%22898.3%22%20height=%22898.3%22%20viewBox=%220%200%20898.3%20898.3%22%3E%3Cpath%20d=%22M120.2%20882.5l433.4-433.3L120.2%2015.8%200%20136l313.2%20313.2L0%20762.3z%22/%3E%3Cpath%20d=%22M344.7%20762.3l120.2%20120.2%20433.4-433.3L464.9%2015.8%20344.7%20136l313.2%20313.2z%22/%3E%3C/svg%3E"
  },
  "design": {
    "board": "go-board",
    "graph": {
      "blocks": [
        {
          "id": "a214789b-db10-4525-ba80-20c320c62a32",
          "type": "basic.output",
          "data": {
            "name": "Segment1",
            "range": "[6:0]",
            "pins": [
              {
                "index": "6",
                "name": "",
                "value": "0"
              },
              {
                "index": "5",
                "name": "",
                "value": "0"
              },
              {
                "index": "4",
                "name": "",
                "value": "0"
              },
              {
                "index": "3",
                "name": "",
                "value": "0"
              },
              {
                "index": "2",
                "name": "",
                "value": "0"
              },
              {
                "index": "1",
                "name": "",
                "value": "0"
              },
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 808,
            "y": 136
          }
        },
        {
          "id": "129a3e9c-cee8-4e02-9114-a44a9515fbef",
          "type": "basic.input",
          "data": {
            "name": "clk",
            "pins": [
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": true
          },
          "position": {
            "x": 128,
            "y": 136
          }
        },
        {
          "id": "d3746d71-9a02-4b67-8de3-1e6db572a1b6",
          "type": "basic.input",
          "data": {
            "name": "input_value",
            "range": "[7:0]",
            "pins": [
              {
                "index": "7",
                "name": "",
                "value": "0"
              },
              {
                "index": "6",
                "name": "",
                "value": "0"
              },
              {
                "index": "5",
                "name": "",
                "value": "0"
              },
              {
                "index": "4",
                "name": "",
                "value": "0"
              },
              {
                "index": "3",
                "name": "",
                "value": "0"
              },
              {
                "index": "2",
                "name": "",
                "value": "0"
              },
              {
                "index": "1",
                "name": "",
                "value": "0"
              },
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true,
            "clock": false
          },
          "position": {
            "x": 128,
            "y": 328
          }
        },
        {
          "id": "0a33152f-2efc-4333-a306-35ed1b32b5c9",
          "type": "basic.output",
          "data": {
            "name": "Segment2",
            "range": "[6:0]",
            "pins": [
              {
                "index": "6",
                "name": "",
                "value": "0"
              },
              {
                "index": "5",
                "name": "",
                "value": "0"
              },
              {
                "index": "4",
                "name": "",
                "value": "0"
              },
              {
                "index": "3",
                "name": "",
                "value": "0"
              },
              {
                "index": "2",
                "name": "",
                "value": "0"
              },
              {
                "index": "1",
                "name": "",
                "value": "0"
              },
              {
                "index": "0",
                "name": "",
                "value": "0"
              }
            ],
            "virtual": true
          },
          "position": {
            "x": 808,
            "y": 328
          }
        },
        {
          "id": "540818d8-c478-45b8-b5af-0fa3f2832ded",
          "type": "basic.code",
          "data": {
            "code": "// @include hex_to_7seg.v\r\n\r\n hex_to_7seg upper_digit\r\n  (.i_Clk(clk),\r\n   .i_Value(data_input[7:4]),\r\n   .o_Segment_A(S1[6]),\r\n   .o_Segment_B(S1[5]),\r\n   .o_Segment_C(S1[4]),\r\n   .o_Segment_D(S1[3]),\r\n   .o_Segment_E(S1[2]),\r\n   .o_Segment_F(S1[1]),\r\n   .o_Segment_G(S1[0]));\r\n\r\n  hex_to_7seg lower_digit\r\n  (.i_Clk(clk),\r\n   .i_Value(data_input[3:0]),\r\n   .o_Segment_A(S2[6]),\r\n   .o_Segment_B(S2[5]),\r\n   .o_Segment_C(S2[4]),\r\n   .o_Segment_D(S2[3]),\r\n   .o_Segment_E(S2[2]),\r\n   .o_Segment_F(S2[1]),\r\n   .o_Segment_G(S2[0]));\r\n",
            "params": [],
            "ports": {
              "in": [
                {
                  "name": "clk"
                },
                {
                  "name": "data_input",
                  "range": "[7:0]",
                  "size": 8
                }
              ],
              "out": [
                {
                  "name": "S1",
                  "range": "[6:0]",
                  "size": 7
                },
                {
                  "name": "S2",
                  "range": "[6:0]",
                  "size": 7
                }
              ]
            }
          },
          "position": {
            "x": 376,
            "y": 72
          },
          "size": {
            "width": 352,
            "height": 384
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "d3746d71-9a02-4b67-8de3-1e6db572a1b6",
            "port": "out"
          },
          "target": {
            "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
            "port": "data_input"
          },
          "size": 8
        },
        {
          "source": {
            "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
            "port": "S1"
          },
          "target": {
            "block": "a214789b-db10-4525-ba80-20c320c62a32",
            "port": "in"
          },
          "size": 7
        },
        {
          "source": {
            "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
            "port": "S2"
          },
          "target": {
            "block": "0a33152f-2efc-4333-a306-35ed1b32b5c9",
            "port": "in"
          },
          "size": 7
        },
        {
          "source": {
            "block": "129a3e9c-cee8-4e02-9114-a44a9515fbef",
            "port": "out"
          },
          "target": {
            "block": "540818d8-c478-45b8-b5af-0fa3f2832ded",
            "port": "clk"
          }
        }
      ]
    },
    "state": {
      "pan": {
        "x": -58,
        "y": 19
      },
      "zoom": 1
    }
  },
  "dependencies": {}
}