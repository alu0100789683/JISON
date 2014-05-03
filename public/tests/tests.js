var assert = chai.assert;


suite('PRUEBAS PARA COMPROBAR LOS ERRORES', function() {
	test('VAR', function() {
   	 	var tree = calculator.parse('var a;begin a = 1 + 2 * 3 / 4 end .')
   	 	$('#output').html(JSON.stringify(tree,undefined,2));
			assert.equal(output.innerHTML,'{\n  "type": "BLOCK",\n  "consts": "NULL",\n  "vars": {\n    "type": "VAR",\n    "var_list": [\n      "a"\n    ]\n  },\n  "procs": "NULL",\n  "stat": {\n    "type": "begin",\n    "statement_list": [\n      {\n        "type": "=",\n        "value": 2.5,\n        "right": "a",\n        "left": {\n          "type": "+",\n          "left": {\n            "type": "NUMBER",\n            "value": 1\n          },\n          "right": {\n            "type": "/",\n            "left": {\n              "type": "*",\n              "left": {\n                "type": "NUMBER",\n                "value": 2\n              },\n              "right": {\n                "type": "NUMBER",\n                "value": 3\n              },\n              "value": 6\n            },\n            "right": {\n              "type": "NUMBER",\n              "value": 4\n            },\n            "value": 1.5\n          },\n          "value": 2.5\n        }\n      }\n    ]\n  }\n}');
    });	
    test('PROCEDURE y BEGIN', function() {
		var tree = calculator.parse('var x; procedure div2; var aux; begin 	aux= 4  end; begin 	x = 1 end.')
   	 	$('#output').html(JSON.stringify(tree,undefined,2));
			assert.equal(output.innerHTML,'{\n  "type": "BLOCK",\n  "consts": "NULL",\n  "vars": {\n    "type": "VAR",\n    "var_list": [\n      "x"\n    ]\n  },\n  "procs": {\n    "type": "procedure",\n    "name": "div2",\n    "bloque": {\n      "type": "BLOCK",\n      "consts": "NULL",\n      "vars": {\n        "type": "VAR",\n        "var_list": [\n          "aux"\n        ]\n      },\n      "procs": "NULL",\n      "stat": {\n        "type": "begin",\n        "statement_list": [\n          {\n            "type": "=",\n            "value": 4,\n            "right": "aux",\n            "left": {\n              "type": "NUMBER",\n              "value": 4\n            }\n          }\n        ]\n      }\n    }\n  },\n  "stat": {\n    "type": "begin",\n    "statement_list": [\n      {\n        "type": "=",\n        "value": 1,\n        "right": "x",\n        "left": {\n          "type": "NUMBER",\n          "value": 1\n        }\n      }\n    ]\n  }\n}');
    });
});

suite('PRUEBAS PARA SITUACIONES DE ERROR', function() {
	test('a = 1 + 2 * 3 / 4 ', function() {
		assert.throws(function() { calculator.parse('a = 1 + 2 * 3 / 4 '); });
	});
	test('var a;. ', function() {
		assert.throws(function() { calculator.parse('var a;. '); });
	});
	test('if a = b then c . ', function() {
		assert.throws(function() { calculator.parse('if a = b then c .'); });
	});
	test('a > b .', function() {
		assert.throws(function() { calculator.parse('a > b .'); });
	});
});

