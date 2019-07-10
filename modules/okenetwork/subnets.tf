# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

locals {
  int_subnet_ad1    = cidrsubnet(var.vcn_cidr, var.newbits["lb"], var.subnets["int_lb_ad1"])
  int_subnet_ad2    = cidrsubnet(var.vcn_cidr, var.newbits["lb"], var.subnets["int_lb_ad2"])
  int_subnet_ad3    = cidrsubnet(var.vcn_cidr, var.newbits["lb"], var.subnets["int_lb_ad3"])
  pub_subnet_ad1    = cidrsubnet(var.vcn_cidr, var.newbits["lb"], var.subnets["pub_lb_ad1"])
  pub_subnet_ad2    = cidrsubnet(var.vcn_cidr, var.newbits["lb"], var.subnets["pub_lb_ad2"])
  pub_subnet_ad3    = cidrsubnet(var.vcn_cidr, var.newbits["lb"], var.subnets["pub_lb_ad3"])
  worker_subnet_ad1 = cidrsubnet(var.vcn_cidr, var.newbits["workers"], var.subnets["workers_ad1"])
  worker_subnet_ad2 = cidrsubnet(var.vcn_cidr, var.newbits["workers"], var.subnets["workers_ad2"])
  worker_subnet_ad3 = cidrsubnet(var.vcn_cidr, var.newbits["workers"], var.subnets["workers_ad3"])

}
resource "oci_core_subnet" "workers_ad1" {
  availability_domain        = element(var.ad_names, 0)
  cidr_block                 = local.worker_subnet_ad1
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-workers-ad1"
  dns_label                  = "w1"
  prohibit_public_ip_on_vnic = var.worker_mode == "private" ? true : false
  route_table_id             = var.worker_mode == "private" ? var.nat_route_id : var.ig_route_id
  security_list_ids          = var.worker_mode == "private" ? [oci_core_security_list.private_workers_seclist[0].id] : [oci_core_security_list.public_workers_seclist[0].id]
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "workers_ad2" {
  availability_domain        = length(var.ad_names) == 3 ? element(var.ad_names, 1) : element(var.ad_names, 0)
  cidr_block                 = local.worker_subnet_ad2
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-workers-ad2"
  dns_label                  = "w2"
  prohibit_public_ip_on_vnic = var.worker_mode == "private" ? true : false
  route_table_id             = var.worker_mode == "private" ? var.nat_route_id : var.ig_route_id
  security_list_ids          = var.worker_mode == "private" ? [oci_core_security_list.private_workers_seclist[0].id] : [oci_core_security_list.public_workers_seclist[0].id]
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "workers_ad3" {
  availability_domain        = length(var.ad_names) == 3 ? element(var.ad_names, 2) : element(var.ad_names, 0)
  cidr_block                 = local.worker_subnet_ad3
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-workers-ad3"
  dns_label                  = "w3"
  prohibit_public_ip_on_vnic = var.worker_mode == "private" ? true : false
  route_table_id             = var.worker_mode == "private" ? var.nat_route_id : var.ig_route_id
  security_list_ids          = var.worker_mode == "private" ? [oci_core_security_list.private_workers_seclist[0].id] : [oci_core_security_list.public_workers_seclist[0].id]
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "int_lb_ad1" {
  availability_domain        = element(var.ad_names, 0)
  cidr_block                 = local.int_subnet_ad1
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-int-lb-ad1"
  dns_label                  = "intlb1"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.int_lb_seclist[0].id]
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "internal" || var.load_balancers== "both" ? 1 : 0
}

resource "oci_core_subnet" "int_lb_ad2" {
  availability_domain        = length(var.ad_names) == 3 ? element(var.ad_names, 1) : element(var.ad_names, 0)
  cidr_block                 = local.int_subnet_ad2
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-int-lb-ad2"
  dns_label                  = "intlb2"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.int_lb_seclist[0].id]
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "internal" || var.load_balancers== "both" ? 1 : 0
}

resource "oci_core_subnet" "int_lb_ad3" {
  availability_domain        = length(var.ad_names) == 3 ? element(var.ad_names, 2) : element(var.ad_names, 0)
  cidr_block                 = local.int_subnet_ad3
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-int-lb-ad3"
  dns_label                  = "intlb3"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.int_lb_seclist[0].id]
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "internal" || var.load_balancers== "both" ? 1 : 0
}

resource "oci_core_subnet" "pub_lb_ad1" {
  availability_domain        = element(var.ad_names, 0)
  cidr_block                 = local.pub_subnet_ad1
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-pub-lb-ad1"
  dns_label                  = "publb1"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.pub_lb_seclist[0].id]
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "public" || var.load_balancers== "both" ? 1 : 0
}

resource "oci_core_subnet" "pub_lb_ad2" {
  availability_domain        = length(var.ad_names) == 3 ? element(var.ad_names, 1) : element(var.ad_names, 0)
  cidr_block                 = local.pub_subnet_ad2
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-pub-lb-ad2"
  dns_label                  = "publb2"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.pub_lb_seclist[0].id]
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "public" || var.load_balancers== "both" ? 1 : 0
}

resource "oci_core_subnet" "pub_lb_ad3" {
  availability_domain        = length(var.ad_names) == 3 ? element(var.ad_names, 2) : element(var.ad_names, 0)
  cidr_block                 = local.pub_subnet_ad3
  compartment_id             = var.compartment_ocid
  display_name               = "${var.label_prefix}-pub-lb-ad3"
  dns_label                  = "publb3"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  security_list_ids          = [oci_core_security_list.pub_lb_seclist[0].id]
  vcn_id                     = var.vcn_id

  count = var.load_balancers == "public" || var.load_balancers== "both" ? 1 : 0
}