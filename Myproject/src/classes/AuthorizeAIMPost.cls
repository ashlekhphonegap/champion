public with sharing class AuthorizeAIMPost {
	
	public string x_login{set;get;}
	public string x_tran_key{set;get;}
	public string transactionId{set;get;}
	public string response{set;get;} 
	
	public Boolean result{set;get;}
	
	public UserInfo UserInfoInstance{set;get;} 
	
	public  AuthorizeInfo authInstance {set;get;}
	
	public  Integer ammount{set;get;}
	
	
	public AuthorizeAIMPost()
	{
		UserInfoInstance = new UserInfo();
		authInstance = new AuthorizeInfo();
		x_login ='9zD5F9SrQC3';
		x_tran_key ='95cum54G4BN4L5D6';
		ammount=20;
		result = false;
		
	}
	
	
	public void pay()
	{
		Map<string,String> allFields = ImportanPAramSet();
		String urldata = '';
		for(String key : allFields.keySet())
		{
			System.debug('---key--- '+key+'----------------'+allFields.get(key));
			urldata += urldata !=''?'&'+Key+'='+EncodingUtil.urlEncode(allFields.get(key), 'UTF-8'):Key+'='+EncodingUtil.urlEncode(allFields.get(key), 'UTF-8');
		}
		
		system.debug('=========================================='+urldata);
		
		List<string> res = payRequest(urldata).split(';');
		if(res != null && res.size()>0)
		{
			transactionId = res[6];
			response= res[0];
			authInstance.x_auth_code = res[4];
			ApexPages.Message msg = new Apexpages.Message(ApexPages.Severity.Info,''+res[3]+':Transaction id:'+transactionId+'. and auth code '+res[4] );
            ApexPages.addmessage(msg);
			
			
		}
		
		
		system.debug('=========================================='+res);
	}
	
	public List<SelectOption> getAuthType()
	{
		List<SelectOption>  x = new List<SelectOption> ();
		x.add(new SelectOption('AUTH_CAPTURE','AUTH CAPTURE') );
		x.add(new SelectOption('AUTH_ONLY','AUTH ONLY') );
		x.add(new SelectOption('CAPTURE_ONLY','CAPTURE ONLY') );
		x.add(new SelectOption('PRIOR_AUTH_CAPTURE','PRIOR AUTH CAPTURE') );
		x.add(new SelectOption('VOID','VOID') );
		return x;
	}
	
	public List<SelectOption> getYear()
	{
		List<SelectOption> curr = new List<SelectOption>();
		for(Integer i = 15;i<25;i++)
			curr.add(new SelectOption(''+i,'20'+i));
		return curr;
	}
	public List<SelectOption> getmonth()
	{
		List<SelectOption> curr = new List<SelectOption>();
		for(Integer i = 1;i<13;i++)
			curr.add(new SelectOption(''+i,''+i));
		return curr;
	}
	
	public List<SelectOption> getcurrenctyType()
	{
		List<SelectOption> curr = new List<SelectOption>();
		curr.add(new SelectOption('AUD','AUD'));
		curr.add(new SelectOption('USD','USD'));
		curr.add(new SelectOption('CAD','CAD'));
		curr.add(new SelectOption('EUR','EUR'));
		curr.add(new SelectOption('GBP','GBP'));
		curr.add(new SelectOption('NZD','NZD'));
		return curr;
	}
	
	
	private Map<string,String> ImportanPAramSet(){
		Map<string,String> param = new Map<String,String>();
		param.put('x_login',x_login);
		param.put('x_tran_key',x_tran_key);
		
		param.put('x_card_num',UserInfoInstance.CardNo);
		param.put('x_exp_date',UserInfoInstance.ExpMonth+UserInfoInstance.ExpYeaar);
		param.put('x_amount',''+ammount);
		param.put('x_currency_code',authInstance.x_currency_code);
		
		if(UserInfoInstance.cardcode != null && UserInfoInstance.cardcode != '')
			param.put('x_card_code',UserInfoInstance.cardcode);
		
		
		//Card holder informaiton
		if(UserInfoInstance.CardNo != null && UserInfoInstance.CardNo != '')
		param.put('x_first_name',UserInfoInstance.first_name);
		
		if(UserInfoInstance.ExpMonth != null && UserInfoInstance.ExpMonth != '')
		param.put('x_last_name',UserInfoInstance.ExpMonth+UserInfoInstance.last_name);
		
		if(UserInfoInstance.company != null && UserInfoInstance.company != '')
		param.put('x_company',UserInfoInstance.company);
		
		if(UserInfoInstance.address != null && UserInfoInstance.address != '')
		param.put('x_address',UserInfoInstance.address);
		
		if(UserInfoInstance.city != null && UserInfoInstance.city != '')
		param.put('x_city',UserInfoInstance.city);
		
		if(UserInfoInstance.state != null && UserInfoInstance.state != '')
		param.put('x_state',UserInfoInstance.state);
		
		if(UserInfoInstance.country != null && UserInfoInstance.country != '')
		param.put('x_country',UserInfoInstance.country);
		
		if(UserInfoInstance.zip != null && UserInfoInstance.zip != '')
		param.put('x_zip',UserInfoInstance.zip);
		
		if(UserInfoInstance.phone != null && UserInfoInstance.phone != '')
		param.put('x_phone',UserInfoInstance.phone);
		
		if(UserInfoInstance.fax != null && UserInfoInstance.fax != '')
		param.put('x_fax',UserInfoInstance.fax);
		
		if(UserInfoInstance.email != null && UserInfoInstance.email != '')
		param.put('x_email',UserInfoInstance.email);
		
		
		param.put('x_version',authInstance.x_version);
		param.put('x_type',authInstance.x_type);
		param.put('x_trans_id',CreateUniqyeNo());
		
		if(authInstance.x_type == 'CAPTURE_ONLY')
			param.put('x_auth_code',authInstance.x_auth_code);
			
		//param.put('x_test_request',authInstance.x_test_request);	
		
		param.put('x_delim_data',authInstance.x_delim_data);
		param.put('x_relay_response',authInstance.x_relay_response);
		
	 	return param;
	}
	
	private String CreateUniqyeNo()
	{
		DateTime d= system.now();
		String s = String.valueOf(d.getTime()*d.getTime()).substring(0,8);
		return s;
	}
	
	public class AuthorizeInfo
	{
		public String x_version {set;get;}
		public String x_type{set;get;}
		public String x_method {set;get;}
		public String x_currency_code {set;get;}
		public String x_trans_id {set;get;}
		public String x_delim_data {set;get;}
		public String x_relay_response {set;get;}
		public String x_auth_code {set;get;}
		public String x_test_request {set;get;}
		public AuthorizeInfo(){
			x_version = '3.1';
			x_relay_response='false';
			x_delim_data ='true';
			x_test_request ='T' ;
		}
		
	}
	public class UserInfo
	{
		public String CardNo {set;get;}
		public string ExpMonth{set;get;}
		public string ExpYeaar{set;get;}
		public String cardcode{set;get;}
		public String first_name{set;get;}
		public String last_name{set;get;}
		public String address{set;get;}
		public String city{set;get;}
		public string state{set;get;}
		public String zip{set;get;}
		public String country{set;get;}
		public String phone{set;get;}
		public String email{set;get;}
		public String company{set;get;}
		public String fax{set;get;}
		
		public UserInfo(){
			CardNo = '370000000000002';
			ExpMonth = '';
			ExpYeaar='';
		}
		
	}
	
	
	public string payRequest(String param)
	{
		String endUrl = 'https://test.authorize.net/gateway/transact.dll';
		//endUrl = endUrl +'?'+param;
		HttpRequest req = new Httprequest();
		req.setMethod('POST');
		req.setEndpoint(endUrl);
		req.setHeader('Content-Type', 'multipart/form-data;boundary=----WebKitFormBoundaryp7MA4YWxkTrZu0gW');
		Http h = new http();
		req.setBody(param);
		req.setHeader('Content-Length',''+param.length());
		Httpresponse res = h.send(req);
		System.debug('::::::::::::::::::::::::::::::'+res.getStatus());
		System.debug('::::::::::::::::::::::::::::::'+res.getBody());
		return res.getBody();
	}
	

}