require_relative "../lib/vbox_folders"
require_relative "../lib/shell_cmd"

include ShellCmd

StatusDbl = Struct.new(:exitstatus)

no_folders = <<-EOF
Oracle VM VirtualBox Guest Additions Command Line Management Interface Version 5.1.38_Ubuntu
(C) 2008-2018 Oracle Corporation
All rights reserved.

Shared Folder mappings (0):

No Shared Folders available.
EOF

dungeon_folder = <<-EOF
Oracle VM VirtualBox Guest Additions Command Line Management Interface Version 5.1.38_Ubuntu
(C) 2008-2018 Oracle Corporation
All rights reserved.

Shared Folder mappings (1):

01 - dungeons
EOF

three_folders = <<-EOF
Oracle VM VirtualBox Guest Additions Command Line Management Interface Version 5.1.38_Ubuntu
(C) 2008-2018 Oracle Corporation
All rights reserved.

Shared Folder mappings (3):

01 - dungeons
02 - istari
03 - cragmore
EOF

inconsistent_folders = <<-EOF
Oracle VM VirtualBox Guest Additions Command Line Management Interface Version 5.1.38_Ubuntu
(C) 2008-2018 Oracle Corporation
All rights reserved.

Shared Folder mappings (0):

01 - dungeons
EOF

describe VboxFolders do
	
	describe "#count" do
		context 'with one shared folder' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: dungeon_folder , stderr: "", status: StatusDbl.new(0)) }

			it 'returns 1' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.count).to eql(1)
			end
		end

		context 'with no shared folders' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: no_folders , stderr: "", status: StatusDbl.new(0)) }

			it 'returns 0' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.count).to eql(0)
			end
		end

		context 'with three shared folders' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: three_folders , stderr: "", status: StatusDbl.new(0)) }

			it 'returns 3' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.count).to eql(3)
			end
		end

		context 'when the shell cmd fails' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: "" , stderr: "Command failed", status: StatusDbl.new(1)) }

			it 'raises a StandardError' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect { vbfs.count }.to raise_error(StandardError)
			end
		end
	end

	describe "#folders" do
		context 'with one shared folder' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: dungeon_folder , stderr: "", status: StatusDbl.new(0)) }

			it 'returns an array with one element' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.folders.length).to eql(1)
			end

			it 'returns the name of the folder' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.folders).to eql(["dungeons"])
			end
		end

		context 'with no shared folders' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: no_folders , stderr: "", status: StatusDbl.new(0)) }

			it 'returns an empty array' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.folders).to eql([])
			end
		end

		context 'with three shared folders' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: three_folders , stderr: "", status: StatusDbl.new(0)) }

			it 'returns the names of all three folders' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect(vbfs.folders).to eql(["dungeons", "istari", "cragmore"])
			end
		end

		context 'when the shell cmd fails' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: "" , stderr: "Command failed", status: StatusDbl.new(1)) }

			it 'raises a StandardError' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect { vbfs.folders }.to raise_error(StandardError)
			end
		end
		
		context 'when the shell cmd counts are inconsistent' do
			let(:resp) { Response.new(cmd: "ip addr show",
				stdout: inconsistent_folders , stderr: "", status: StatusDbl.new(0)) }

			it 'raises a StandardError' do
				cmd = double("shell command")
				expect(cmd).to receive(:call).with("sudo VBoxControl sharedfolder list").and_return(resp)
				vbfs = VboxFolders.new(shell: cmd)
				expect { vbfs.folders }.to raise_error(StandardError)
			end
		end
	end
end
