FROM archlinux/base
RUN pacman -Sy --noconfirm base-devel
RUN cat > /etc/sudoers.d/nobody <<< 'nobody ALL=(ALL) NOPASSWD: ALL'
USER nobody
RUN mkdir /tmp/pkg
WORKDIR /tmp/pkg
RUN curl -s https://aur.archlinux.org/cgit/aur.git/snapshot/openswan.tar.gz | tar xzf - --strip-components=1
RUN makepkg --noconfirm -sr

FROM archlinux/base
COPY --from=0 /tmp/pkg/*.pkg.tar.xz .
