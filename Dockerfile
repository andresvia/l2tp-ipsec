FROM archlinux/base
RUN pacman -Sy --noconfirm base-devel
RUN cat > /etc/sudoers.d/nobody <<< 'nobody ALL=(ALL) NOPASSWD: ALL'
USER nobody
RUN mkdir /tmp/pkg
WORKDIR /tmp/pkg
RUN curl -s https://aur.archlinux.org/cgit/aur.git/snapshot/openswan.tar.gz | tar xzf - --strip-components=1
RUN makepkg -sri --noconfirm
USER root
WORKDIR /
RUN rm -rf /tmp/pkg /etc/sudoers.d/nobody

# FROM archlinux/base
# COPY --from=0 /tmp/pkg/*.pkg.tar.xz .
# install *.pkg.tar.xz

RUN pacman -Sy --noconfirm python2 rsyslog xl2tpd
ADD etc_ipsec.conf.envsubst /etc/ipsec.conf.envsubst
ADD etc_ipsec.secrets.envsubst /etc/ipsec.secrets.envsubst
ADD etc_xl2tpd_xl2tpd.conf.envsubst /etc/xl2tpd/xl2tpd.conf.envsubst
ADD etc_ppp_options.l2tpd.client.envsubst /etc/ppp/options.l2tpd.client.envsubst
ADD up.sh /tmp/up.sh
ENTRYPOINT [ "/tmp/up.sh" ]
