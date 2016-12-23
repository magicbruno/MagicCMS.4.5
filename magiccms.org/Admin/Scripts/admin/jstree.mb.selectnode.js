;(function ($) {
	$.mb_selectnode = function (tree,data_pk, json_tree, select) {
		for (var i = 0; i < json_tree.length; i++) {
			var node = json_tree[i];
			if (node.a_attr['data-pk'] == data_pk)  {
				if (select)
					tree.select_node(node);
				else
					tree.deselect_node(node);
			}
			if (node.children.length)
				$.mb_selectnode(tree, data_pk, node.children, select);
		}
	}

})(jQuery);