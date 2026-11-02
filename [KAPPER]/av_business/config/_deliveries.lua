-- Only the jobs with access to Products Tab will be allowed to use this function
Delivery = {}
Delivery['stash'] = {
    label = "Customer",
    weight = 100000,
    slots = deliveries_config and deliveries_config['maxProducts'] or 50,
}
