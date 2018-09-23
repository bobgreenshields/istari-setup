require_relative "../lib/ip"
require_relative "../lib/shell_cmd"

include ShellCmd

StatusDbl = Struct.new(:exitstatus)

ip_addr_show = <<-EOF
				expect(ip.split_by_interface(ip_addr_show)).to be_kind_of(Array)
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 2c:fd:a1:5d:41:27 brd ff:ff:ff:ff:ff:ff
    inet 172.16.77.134/24 brd 172.16.77.255 scope global dynamic enp0s31f6
       valid_lft 80372sec preferred_lft 80372sec
    inet6 fe80::d3f4:6138:240f:cd62/64 scope link 
       valid_lft forever preferred_lft forever
3: wlp3s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 98:22:ef:93:93:6b brd ff:ff:ff:ff:ff:ff
EOF

describe Ip do
	describe "#call" do
		context 'with a valid shell response' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: ip_addr_show , stderr: "", status: StatusDbl.new(0)) }

			it 'returns an array' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("ip addr show").and_return(resp)
				ip = Ip.new(shell: cmd)
				expect(ip.call).to be_kind_of(Array)
			end

			it 'returns an array of the intf_ips' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("ip addr show").and_return(resp)
				ip = Ip.new(shell: cmd)
				expect(ip.call).to eql(["172.16.77.134"])
			end
		end	

		context 'with a failed shell response' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: "" , stderr: "Command failed", status: StatusDbl.new(1)) }

			it 'raises a StandardError' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("ip addr show").and_return(resp)
				ip = Ip.new(shell: cmd)
				expect { ip.call }.to raise_error(StandardError)
			end
			
		end
	end

	describe "interfaces" do
		context 'with a valid shell response' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: ip_addr_show , stderr: "", status: StatusDbl.new(0)) }

			it 'returns an array' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("ip addr show").and_return(resp)
				ip = Ip.new(shell: cmd)
				expect(ip.interfaces).to be_kind_of(Array)
			end

			it 'returns an array of the interfaces' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("ip addr show").and_return(resp)
				ip = Ip.new(shell: cmd)
				expect(ip.interfaces).to eql([{ name: "enp0s31f6", ip: "172.16.77.134"}])
			end
		end	

		context 'with a failed shell response' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: "" , stderr: "Command failed", status: StatusDbl.new(1)) }

			it 'raises a StandardError' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("ip addr show").and_return(resp)
				ip = Ip.new(shell: cmd)
				expect { ip.interfaces }.to raise_error(StandardError)
			end
			
		end
	end

	describe "#intf_ips" do
		let(:ip) { Ip.new }
		it 'returns an array' do
			expect(ip.intf_ips(ip_addr_show)).to be_a_kind_of(Array)
		end

		it 'contains the interfaces with ip addresses' do
			expect(ip.intf_ips(ip_addr_show)).to include({name: "enp0s31f6", ip: "172.16.77.134"})
		end

		it 'does not include lo' do
			expect(ip.intf_ips(ip_addr_show).map { |intf| intf[:name] }).
				not_to include("lo")
		end
	end
	
end
