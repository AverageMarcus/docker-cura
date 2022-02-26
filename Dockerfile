FROM jlesage/baseimage-gui:debian-10  AS BUILDER
  RUN apt update && apt install -y curl

  RUN curl -L -O https://github.com/Ultimaker/Cura/releases/download/4.13.1/Ultimaker_Cura-4.13.1.AppImage && \
    chmod a+x Ultimaker_Cura-4.13.1.AppImage && \
    cp Ultimaker_Cura-4.13.1.AppImage /usr/bin/Ultimaker_Cura-4.13.1.AppImage

  RUN /usr/bin/Ultimaker_Cura-4.13.1.AppImage --appimage-extract && \
    mv /tmp/squashfs-root /opt/cura && \
    chmod +x /opt/cura/usr/bin/cura.sh

FROM jlesage/baseimage-gui:debian-10
  COPY --from=BUILDER /opt/cura /opt/cura

  RUN sed-patch 's/<application type="normal">/<application type="normal" title="Ultimaker Cura">/' /etc/xdg/openbox/rc.xml && \
    ln -s /opt/cura/usr/bin/cura /usr/bin/cura

  ADD ./src/startapp.sh /startapp.sh

  RUN mkdir -p /app/cura && \
    mkdir -p /config/xdg/config/cura && \
    ln -sf /app/cura /config/xdg/config/cura/4.13

  VOLUME [ "/app/cura" ]
  ENV APP_NAME="Cura"
  ENV USER_ID=0
  ENV GROUP_ID=0
  ENV DISPLAY_WIDTH=2340
  ENV DISPLAY_HEIGHT=1542
  ENV KEEP_APP_RUNNING=1
