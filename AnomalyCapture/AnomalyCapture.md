启动Crash

启动Crash再launch之前，监控启动Crash必须放在load和launch之间，启动顺序是：load->category load->constructor->initialize->main->launch
