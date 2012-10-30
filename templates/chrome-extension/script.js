
var Script = {};

Script['background'] = function () {
};

Script['options'] = function () {
};

window.onload = function () {
	try {
		Script[document.title]();
	} catch (e) {
		console.log(e);
	}
};

