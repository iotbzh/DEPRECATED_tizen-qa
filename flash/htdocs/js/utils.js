(function() {

//var DEBUG=true;

window.utils = {
	// Asynchronously load templates located in separate .html files
	loadTemplate: function(views, callback) {
		var deferreds = [];

		_.keys(views).forEach(function(klass) {
			var path=views[klass];

			if (window[klass]) {
				deferreds.push($.get(path, function(data) {
					window[klass].prototype.template = _.template(data);
				}));
			} else {
				alert(klass + " not found");
			}
		});
		
		$.when.apply(null, deferreds).done(callback);
	},
	
	uploadFile: function (file, callbackSuccess) {
		var self = this;
		var data = new FormData();
		data.append('file', file);
		$.ajax({
			url: 'api/upload.php',
			type: 'POST',
			data: data,
			processData: false,
			cache: false,
			contentType: false
		})
		.done(function () {
			console.log(file.name + " uploaded successfully");
			callbackSuccess();
		})
		.fail(function () {
			self.showAlert('Error!', 'An error occurred while uploading ' + file.name, 'alert-error');
		});
	},
	
	displayValidationErrors: function (messages) {
		for (var key in messages) {
			if (messages.hasOwnProperty(key)) {
				this.addValidationError(key, messages[key]);
			}
		}
		this.showAlert('Warning!', 'Fix validation errors and try again', 'alert-warning');
	},
	
	addValidationError: function (field, message) {
		var controlGroup = $('#' + field).parent().parent();
		controlGroup.addClass('error');
		$('.help-inline', controlGroup).html(message);
	},
	
	removeValidationError: function (field) {
		var controlGroup = $('#' + field).parent().parent();
		controlGroup.removeClass('error');
		$('.help-inline', controlGroup).html('');
	},
	
	showAlert: function(title, text, klass) {
		$('.alert').removeClass("alert-error alert-warning alert-success alert-info");
		$('.alert').addClass(klass || "alert-info");
		$('.alert').html('<strong>' + title + '</strong> ' + text);
		$('.alert').show();
		setTimeout(function() { $('.alert').hide(500); }, 2000);
	},
	
	hideAlert: function() {
		$('.alert').hide();
	},

	now: function() {
		return +(new Date());
	}
};

})();
