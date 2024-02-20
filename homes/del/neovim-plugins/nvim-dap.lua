local dap = require('dap')

dap.adapters.cs = {
	type = 'server';
	port = 4711;
}

dap.configurations.cs = {
	{
		type = 'cs';
		request = 'launch';
	},
}
