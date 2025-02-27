// 
//                  Simu5G
//
// Authors: Giovanni Nardini, Giovanni Stea, Antonio Virdis (University of Pisa)
// 
// This file is part of a software released under the license included in file
// "license.pdf". Please read LICENSE and README files before using it.
// The above files and the present reference are part of the software itself, 
// and cannot be removed from it.
// 
package simu5g.simulations.SatCom.networks;

import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.ethernet.Eth10G;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import simu5g.common.binder.Binder;
import simu5g.common.carrierAggregation.CarrierAggregation;
import simu5g.nodes.Upf;
import simu5g.nodes.SatCom.gNBSatellite;
import simu5g.nodes.NR.NRUe;
import simu5g.nodes.backgroundCell.BackgroundCell;
import simu5g.world.radio.LteChannelControl;

// MultiCell_standalone
//
// This network represents the deployment option 3 in 3GPP 38.801
//
network MultiSatellite_Standalone
{
    parameters:
        int numUe = default(1);
        int numBgCells = default(0);
        @display("i=block/network2;bgb=1088.032,678.896;bgi=background/pisa");
    submodules:
        channelControl: LteChannelControl {
            @display("p=50,25;is=s");
        }
        routingRecorder: RoutingTableRecorder {
            @display("p=50,75;is=s");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=50,125");
        }
        binder: Binder {
            @display("p=50,175;is=s");
        }
        carrierAggregation: CarrierAggregation {
            @display("p=50.993748,258.7;is=s");
        }
        server: StandardHost {
            @display("p=212,118;is=n;i=device/server");
        }
        router: Router {
            @display("p=351.81198,115.771996;i=device/smallrouter");
        }
        upf: Upf {
            @display("p=500,115");
        }
        iUpf: Upf {
            @display("p=500,215");
        }
        gnbSat1: gNBSatellite {
            @display("p=250,300;is=vl");
        }
        gnbSat2: gNBSatellite {
            @display("p=750,300.556;is=vl");
        }
        bgCell[numBgCells]: BackgroundCell {
            @display("p=249.528,483.31998;is=vl");
        }
        ue[numUe]: NRUe {
            @display("p=499.056,428.244");
        }
    connections:

        //# Data Network connections
        server.pppg++ <--> Eth10G <--> router.pppg++;
        router.pppg++ <--> Eth10G <--> upf.filterGate;

        //# 5G Core Network connections
        upf.pppg++ <--> Eth10G <--> iUpf.pppg++;
        iUpf.pppg++ <--> Eth10G <--> gnbSat1.ppp;
        iUpf.pppg++ <--> Eth10G <--> gnbSat2.ppp;

        //# X2 connections
        gnbSat1.x2++ <--> Eth10G <--> gnbSat2.x2++;
}
