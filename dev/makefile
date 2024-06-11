#
# Create test files & dirs
#
TF=test-files

setup:
	# Compile socket program
	zig cc create-socket.c -o create-socket

	# Clean out test files dir
	rm -rf $(TF)/*

	# Make dirs
	mkdir -p $(TF) \
	$(TF)/dir \
	$(TF)/dir-sticky-bit \
	$(TF)/dir-writable-grp \
	$(TF)/dir-writable-oth \
	$(TF)/dir-writable-oth-sticky-bit

	chmod +t $(TF)/dir-sticky-bit
	chmod g+w $(TF)/dir-writable-grp
	chmod o+w $(TF)/dir-writable-oth
	chmod +t,g-x,o-x $(TF)/dir-writable-oth-sticky-bit

	# Make files
	touch	$(TF)/file \
	$(TF)/file-suid \
	$(TF)/file-sgid \
	$(TF)/file-suid-sgid \
	$(TF)/file-executable \
	$(TF)/file-executable-usr \
	$(TF)/file-executable-grp \
	$(TF)/file-executable-oth \
	$(TF)/file-executable-suid \
	$(TF)/file-executable-sgid \
	$(TF)/dir/symlink-target \

	chmod u+s $(TF)/file-suid
	chmod g+s $(TF)/file-sgid
	chmod u+s,g+s $(TF)/file-suid-sgid
	chmod a+x $(TF)/file-executable
	chmod u+x $(TF)/file-executable-usr
	chmod g+x $(TF)/file-executable-grp
	chmod o+x $(TF)/file-executable-oth
	chmod u+s,+x $(TF)/file-executable-suid
	chmod g+s,+x $(TF)/file-executable-sgid

	# Make symlinks
	ln -s dir/symlink-target $(TF)/symlink
	ln -s ../../non-existent-file $(TF)/symlink-orphan
	ln -s ../README.md $(TF)/symlink-relative
	ln -s /dev/null $(TF)/symlink-absolute

	# Make device files
	sudo mknod $(TF)/device-block b 0 0
	sudo mknod $(TF)/device-character c 0 0

	# Make Pipe and socket
	mkfifo $(TF)/pipe
	./create-socket $(TF)/socket

#
# Clean up test files & dirs
#
setup-clean:
	rm -rf $(TF)
	rm -f create-socket

.PHONY: setup setup-clean
